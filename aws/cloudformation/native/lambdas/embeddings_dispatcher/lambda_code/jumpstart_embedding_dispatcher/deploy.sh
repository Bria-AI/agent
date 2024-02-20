docker push 542375318953.dkr.ecr.us-east-1.amazonaws.com/jumpstart_embedding_dispatcher:latest

docker build --platform linux/amd64 -t jumpstart_embedding_dispatcher .

docker tag jumpstart_embedding_dispatcher:latest 542375318953.dkr.ecr.us-east-1.amazonaws.com/jumpstart_embedding_dispatcher:latest
# docker build --platform linux/amd64 -t jumpstart_embedding_dispatcher:latest public.ecr.aws/b6e6a5j8/jumpstart_embedding_dispatcher:latest .

docker push 542375318953.dkr.ecr.us-east-1.amazonaws.com/jumpstart_embedding_dispatcher:latest
# Go to lambda (https://us-east-1.console.aws.amazon.com/lambda/home?region=us-east-1#/functions/index_asset?tab=image) and update image !!!!
# aws lambda invoke --function-name index_asset  --invocation-type Event --cli-binary-format raw-in-base64-out --payload '{ "max_workers": 1000, "dry_run": true }' response.json
