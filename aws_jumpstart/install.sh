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
    config_file="--parameters $(cat $config_file_name | jq -r '.[] | "ParameterKey=" + .ParameterKey + ",ParameterValue=" + .ParameterValue')"
fi


aws_account_id=$(aws sts get-caller-identity --query "Account" --output text)
if [ -z "$aws_account_id" ]; then
    echo "Failed to retrieve AWS account ID"
    exit 1
fi

role_arn="arn:aws:iam::$aws_account_id:role/jumpstart-bria-agent-role"


# copy to s3
aws s3 sync . s3://$bucket_name/ --exclude "*.py" --exclude "*.pyc"
aws cloudformation create-stack --stack-name $stack_name-role --template-body file://iam_role_stack.yml --capabilities CAPABILITY_NAMED_IAM CAPABILITY_AUTO_EXPAND
aws cloudformation wait stack-create-complete --stack-name $stack_name-role

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
    aws cloudformation create-stack --stack-name $stack_name --template-body file://master.yml --capabilities CAPABILITY_NAMED_IAM CAPABILITY_AUTO_EXPAND $config_file ParameterKey=MainRole,ParameterValue=$role_arn --role-arn $role_arn 
}

function update_stack() {
    echo "Updating stack $stack_name"
    aws cloudformation update-stack --stack-name $stack_name --template-body file://master.yml --capabilities CAPABILITY_NAMED_IAM CAPABILITY_AUTO_EXPAND $config_file ParameterKey=MainRole,ParameterValue=$role_arn --role-arn $role_arn 
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



