#!/bin/bash

# Variables
bucket_name="jumpstart-bria-agent"
stack_name="jumpstart-bria-agent"
template_file="master.yml"

aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 300465780738.dkr.ecr.us-east-1.amazonaws.com

# copy to s3
aws s3 sync . s3://$bucket_name/ --exclude "*.py" --exclude "*.pyc"

# Step 2: Update CloudFormation Stack
echo "Updating CloudFormation stack $stack_name..."
# aws cloudformation create-stack --stack-name $stack_name --template-body file://$template_file --capabilities CAPABILITY_NAMED_IAM CAPABILITY_AUTO_EXPAND --role-arn arn:aws:iam::300465780738:role/bria-agent
aws cloudformation update-stack --stack-name $stack_name --template-body file://$template_file --capabilities CAPABILITY_NAMED_IAM CAPABILITY_AUTO_EXPAND

echo "Update process initiated. Check the AWS CloudFormation console for progress."
