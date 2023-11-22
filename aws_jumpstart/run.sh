#!/bin/bash

# Assign command line arguments to variables
stack_name=${1:-jumpstart-bria-agent}
bucket_name=${2:-jumpstart-bria-agent}
template_file=${3:-master.yml}
config_file_name=${4:-config.json}

# Check if required parameters are provided
if [ -z "$bucket_name" ] || [ -z "$stack_name" ]; then
    echo "Usage: $0 [stack_name] [bucket_name] [template_file]"
    echo "bucket_name and stack_name are required."
    echo "template_file is optional and defaults to 'master.yml'."
    exit 1
fi

config_file=""
if [ -f "$config_file_name" ]; then
    config_file="--parameters file://$config_file_name"
fi

# Step 1: Sync current folder to S3
echo "Uploading current folder to S3 bucket $bucket_name..."
python3 -m venv venv
source venv/bin/activate

# create zip dir
mkdir lambdas/api_endpoint_lambda/build_zip

# copy code base to zip dir
cp -r lambdas/api_endpoint_lambda/code/ lambdas/api_endpoint_lambda/build_zip/
python3 -m pip install --upgrade pip
pip install sagemaker --no-cache-dir
pip install rpds --no-cache-dir
pip install rpds-py==0.5.3 --no-cache-dir
pip install urllib3==1.26.6 --no-cache-dir
cp -r venv/lib/python3.11/site-packages/* lambdas/api_endpoint_lambda/build_zip/

# create zip
cd lambdas/api_endpoint_lambda/build_zip/
zip -r ../endpoint_lambda_code.zip .

# return to base dir
cd -

# remove venv
rm -rf venv
rm -rf lambdas/api_endpoint_lambda/build_zip/

# copy to s3
aws s3 sync . s3://$bucket_name/ --exclude "*.py" --exclude "*.pyc"

# Step 2: Update CloudFormation Stack
echo "Updating CloudFormation stack $stack_name..."

function stack_exists() {
    aws cloudformation describe-stacks --stack-name $stack_name > /dev/null 2>&1
    return $?
}

function stack_failed() {
    local stack_status=$(aws cloudformation describe-stacks --stack-name $stack_name --query "Stacks[0].StackStatus" --output text 2> /dev/null)
    local status

    case $stack_status in
    "ROLLBACK_COMPLETE")
	status=0
        ;;
    *)
	status=1
	;;
    esac

    return $status
}

function create_stack() {
    echo "Creating stack $stack_name"
    aws cloudformation create-stack --stack-name $stack_name --template-body file://master.yml --capabilities CAPABILITY_NAMED_IAM CAPABILITY_AUTO_EXPAND $config_file
}

function update_stack() {
    echo "Updating stack $stack_name"
    aws cloudformation update-stack --stack-name $stack_name --template-body file://master.yml --capabilities CAPABILITY_NAMED_IAM CAPABILITY_AUTO_EXPAND $config_file
}

function delete_stack() {
    echo "Deleting stack $stack_name"
    aws cloudformation delete-stack --stack-name $stack_name
}

function deploy() {
    if stack_exists; then
	if stack_failed; then
	    delete_stack
	    create_stack
	else
	    update_stack
	fi
    else
	create_stack
    fi

    return $?
}

if deploy; then
    echo "Update process initiated. Check the AWS CloudFormation console for progress."
else
    echo "Update process failed."
fi



