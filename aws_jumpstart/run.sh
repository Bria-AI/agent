#!/bin/bash

# Variables
bucket_name="jumpstart-bria-agent"
stack_name="jumpstart-bria-agent"
template_file="master.yml"

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
# connect to ecr repo for pulling docker image
# aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 785573368785.dkr.ecr.us-east-1.amazonaws.com

# Step 2: Update CloudFormation Stack
echo "Updating CloudFormation stack $stack_name..."
# aws cloudformation update-stack --stack-name $stack_name --template-body file://master.yml --capabilities CAPABILITY_NAMED_IAM CAPABILITY_AUTO_EXPAND  --role-arn arn:aws:iam::300465780738:role/bria-agent
aws cloudformation update-stack --stack-name $stack_name --template-body file://master.yml --capabilities CAPABILITY_NAMED_IAM CAPABILITY_AUTO_EXPAND
# aws cloudformation create-stack --stack-name $stack_name  --template-body file://master.yml --capabilities CAPABILITY_NAMED_IAM CAPABILITY_AUTO_EXPAND --role-arn arn:aws:iam::300465780738:role/bria-agent 
#   --user-ARN arn:aws:iam::300465780738:user/Itay

echo "Update process initiated. Check the AWS CloudFormation console for progress."

