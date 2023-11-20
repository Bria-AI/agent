#!/bin/bash

# Variables
bucket_name="jumpstart-bria-agent"
stack_name="jumpstart-bria-agent"
template_file="master.yml"

# Step 1: Sync current folder to S3
echo "Uploading current folder to S3 bucket $bucket_name..."
aws s3 sync . s3://$bucket_name/
zip -r lambdas/api_endpoint_lambda/endpoint_lambda_code.zip lambdas/api_endpoint_lambda/endpoint_lambda_code.py
# connect to ecr repo for pulling docker image
# aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 785573368785.dkr.ecr.us-east-1.amazonaws.com

# Step 2: Update CloudFormation Stack
echo "Updating CloudFormation stack $stack_name..."
# aws cloudformation update-stack --stack-name $stack_name --template-body file://master.yml --capabilities CAPABILITY_NAMED_IAM CAPABILITY_AUTO_EXPAND  --role-arn arn:aws:iam::300465780738:role/bria-agent
aws cloudformation update-stack --stack-name $stack_name --template-body file://master.yml --capabilities CAPABILITY_NAMED_IAM CAPABILITY_AUTO_EXPAND
# aws cloudformation create-stack --stack-name $stack_name  --template-body file://master.yml --capabilities CAPABILITY_NAMED_IAM CAPABILITY_AUTO_EXPAND --role-arn arn:aws:iam::300465780738:role/bria-agent 
#   --user-ARN arn:aws:iam::300465780738:user/Itay

echo "Update process initiated. Check the AWS CloudFormation console for progress."

