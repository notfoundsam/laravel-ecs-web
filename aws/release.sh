#!/bin/bash

OS=$1
AWS_PROFILE=$2
AWS_ACCOUNT_ID=$3
AWS_REGION_NAME=$4
CLUSTER_NAME=$5
PROJECT_NAME=$6
APP_ENV=$7

if [ $1 == 'mac' ]
then
  SED_BACK='.bak'
elif [ $1 == 'linux' ]
then
  SED_BACK=''
else
  echo Unknown platform
  exit 1
fi

VERSION=$(git rev-parse --short HEAD)
echo Relaese version:$VERSION

# AWS CLI in docker
AWS="docker run --rm -it -v ~/.aws:/root/.aws -v $(pwd)/aws:/aws -e AWS_PROFILE=$AWS_PROFILE -e AWS_PAGER="" amazon/aws-cli"

# Docker images
IMAGE_PHP="$AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION_NAME.amazonaws.com/$PROJECT_NAME-php-fpm:$APP_ENV-$VERSION"
IMAGE_NGINX="$AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION_NAME.amazonaws.com/$PROJECT_NAME-nginx:$APP_ENV-$VERSION"

# ECS variables
ECS_SERVICE_NAME="$PROJECT_NAME-$APP_ENV-app"
ECS_TASK_NAME="$PROJECT_NAME-app"

echo Build docker images...
docker build -q -t $IMAGE_PHP -f docker/PhpProd.dockerfile .
docker build -q -t $IMAGE_NGINX -f docker/NginxProd.dockerfile .

echo Login to AWS ECR
#aws ecr get-login --profile $AWS_PROFILE --no-include-email
AWS_PASSWORD=$(eval $AWS ecr get-login-password)
docker login -u AWS -p $AWS_PASSWORD $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION_NAME.amazonaws.com
if [ $? -eq 0 ]
then
  echo Login to AWS successed
else
  echo Login to AWS failed
  exit 1
fi

echo Push images to AWS ECR...
docker push $IMAGE_PHP
docker push $IMAGE_NGINX
if [ $? -eq 0 ]
then
  echo Images pushed
else
  echo Pushing images failed
  exit 1
fi

echo Create migration task
sed -e 's/app_environment/'$APP_ENV'/g; s/app_version/'$VERSION'/g; s/project_name/'$PROJECT_NAME'/g; s/region_name/'$AWS_REGION_NAME'/g; s/account_id/'$AWS_ACCOUNT_ID'/g; s/db_command/migrate/g' aws/task-definition-migrate.json > aws/task-definition-migrate.json.tmp
TASK_REVISION_MIGRATE=$(eval $AWS ecs register-task-definition --cli-input-json file://task-definition-migrate.json.tmp --query 'taskDefinition.revision' | tr -d '\r\n')

if [ $? -eq 0 ]
then
  echo Task ID:$TASK_REVISION_MIGRATE
else
  echo Create migration task failed
  echo $TASK_REVISION_MIGRATE
  exit 1
fi

echo Run migration task
sed -e 's/cluster_name/'$CLUSTER_NAME'/g; s/task_definition_name/'$PROJECT_NAME'-migrate/g; s/task_revision/'$TASK_REVISION_MIGRATE'/g' aws/run-task-migrate.json > aws/run-task-migrate.json.tmp
TASK_ARN=$(eval $AWS ecs run-task --cli-input-json file://run-task-migrate.json.tmp --query 'tasks[0].taskArn' | tr -d '\r\n')

if [ $? -eq 0 ]
then
  echo Task ARN:$TASK_ARN
else
  echo Runing migration task failed
  echo $TASK_ARN
  exit 1
fi

echo Waiting for migration task stopped
eval $AWS ecs wait tasks-stopped --cluster $CLUSTER_NAME --tasks $TASK_ARN

echo Create application task
sed -e 's/app_environment/'$APP_ENV'/g; s/app_version/'$VERSION'/g; s/project_name/'$PROJECT_NAME'/g; s/region_name/'$AWS_REGION_NAME'/g; s/account_id/'$AWS_ACCOUNT_ID'/g' aws/task-definition-app.json > aws/task-definition-app.json.tmp
TASK_REVISION_APP=$(eval $AWS ecs register-task-definition --cli-input-json file://task-definition-app.json.tmp --query 'taskDefinition.revision')

if [ $? -eq 0 ]
then
  echo Task ID:$TASK_REVISION_APP
else
  echo Create application task
  echo $TASK_REVISION_APP
  exit 1
fi

echo Start updating application service
APP_OUTPUT=$(eval $AWS ecs update-service --cluster $CLUSTER_NAME --service $ECS_SERVICE_NAME --task-definition $ECS_TASK_NAME:$TASK_REVISION_APP)

echo $AWS ecs update-service --cluster $CLUSTER_NAME --service $ECS_SERVICE_NAME --task-definition $ECS_TASK_NAME:$TASK_REVISION_APP

if [ $? -eq 0 ]
then
  echo $APP_OUTPUT
else
  echo Updating application service filed
  echo $APP_OUTPUT
  exit 1
fi

echo Waiting for service stable...
eval $AWS ecs wait services-stable --cluster $CLUSTER_NAME --services $ECS_SERVICE_NAME

echo Clean up
find aws/ -name "*.tmp" -type f -delete

echo Complete!
