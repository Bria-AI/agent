FROM public.ecr.aws/lambda/python:3.9

RUN yum install -y gcc git

COPY requirements.txt  ${LAMBDA_TASK_ROOT}
RUN pip3 install -r requirements.txt --target "${LAMBDA_TASK_ROOT}"

COPY lambda_function.py ${LAMBDA_TASK_ROOT}

CMD [ "lambda_function.handler" ]
