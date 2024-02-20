aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 542375318953.dkr.ecr.us-east-1.amazonaws.com

docker build --platform linux/amd64 -t agent_image_embeddings_calculator .

docker tag agent_image_embeddings_calculator:latest 542375318953.dkr.ecr.us-east-1.amazonaws.com/agent_image_embeddings_calculator:latest
# docker build --platform linux/amd64 -t agent_image_embeddings_calculator:latest public.ecr.aws/b6e6a5j8/agent_image_embeddings_calculator:latest .

docker push 542375318953.dkr.ecr.us-east-1.amazonaws.com/agent_image_embeddings_calculator:latest
# Go to lambda (https://us-east-1.console.aws.amazon.com/lambda/home?region=us-east-1#/functions/index_asset?tab=image) and update image !!!!
# aws lambda invoke --function-name index_asset  --invocation-type Event --cli-binary-format raw-in-base64-out --payload '{ "max_workers": 1000, "dry_run": true }' response.json
