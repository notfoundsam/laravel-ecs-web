#!/bin/bash

OS=$1
PROJECT_NAME=$2
AWS_REGION_NAME=$3
AWS_ACCOUNT_ID=$4
APP_ENV=production

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

echo Build docker images...
docker build -q -t $AWS_ACCOUNT_ID.dkr.ecr.ap-northeast-1.amazonaws.com/$PROJECT_NAME-php-fpm:$APP_ENV-$VERSION -f docker/PhpProd.dockerfile .
docker build -q -t $AWS_ACCOUNT_ID.dkr.ecr.ap-northeast-1.amazonaws.com/$PROJECT_NAME-nginx:$APP_ENV-$VERSION -f docker/NginxProd.dockerfile .

echo Login to AWS ECR
#aws ecr get-login --profile $PROJECT_NAME --no-include-email
docker login -u AWS -p $(aws ecr get-login-password --profile $PROJECT_NAME) $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION_NAME.amazonaws.com
if [ $? -eq 0 ]
then
  echo Login to AWS successed
else
  echo Login to AWS failed
  exit 1
fi

echo Push images to AWS ECR...
docker push $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION_NAME.amazonaws.com/$PROJECT_NAME-php-fpm:$APP_ENV-$VERSION
docker push $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION_NAME.amazonaws.com/$PROJECT_NAME-nginx:$APP_ENV-$VERSION
if [ $? -eq 0 ]
then
  echo Images pushed
else
  echo Pushing images failed
  exit 1
fi

echo Replace AWS json files
git checkout HEAD -- aws/task-definition-app.json
git checkout HEAD -- aws/task-definition-migrate.json
sed -i $SED_BACK -e 's/app_environment/'$APP_ENV'/g; s/app_version/'$VERSION'/g; s/project_name/'$PROJECT_NAME'/g; s/region_name/'$AWS_REGION_NAME'/g; s/account_id/'$AWS_ACCOUNT_ID'/g' aws/task-definition-app.json
sed -i $SED_BACK -e 's/app_environment/'$APP_ENV'/g; s/app_version/'$VERSION'/g; s/project_name/'$PROJECT_NAME'/g; s/region_name/'$AWS_REGION_NAME'/g; s/account_id/'$AWS_ACCOUNT_ID'/g; s/db_command/migrate/g' aws/task-definition-migrate.json


echo Create task definition
TASK_REVISION_MIGRATE=$(aws --profile $PROJECT_NAME ecs register-task-definition --cli-input-json file://aws/task-definition-migrate.json | jq --raw-output '.taskDefinition.revision')
if [ $? -eq 0 ]
then
  echo Task ID:$TASK_REVISION_MIGRATE
else
  echo Create task definition failed
  exit 1
fi

echo Replace AWS json migrate
git checkout HEAD -- aws/run-task-migrate.json
sed -i $SED_BACK -e 's/project_name/'$PROJECT_NAME'/g; s/task_revision/'$TASK_REVISION_MIGRATE'/g' aws/run-task-migrate.json

echo Run migration task
TASK_ARN=$(aws --profile $PROJECT_NAME ecs run-task --cli-input-json file://aws/run-task-migrate.json | jq -r '.tasks[0].taskArn')
echo Task ARN:$TASK_ARN

echo Waiting for task stoping
aws --profile $PROJECT_NAME ecs wait tasks-stopped --cluster $PROJECT_NAME-main --tasks $TASK_ARN

TASK_REVISION_APP=$(aws --profile $PROJECT_NAME ecs register-task-definition --cli-input-json file://aws/task-definition-app.json | jq --raw-output '.taskDefinition.revision')
echo Task revesion app: $TASK_REVISION_APP

echo Start updating app service
APP_OUTPUT=$(aws --profile $PROJECT_NAME ecs update-service --cluster $PROJECT_NAME-main --service $PROJECT_NAME-web-$APP_ENV-app --task-definition $PROJECT_NAME-web-app:$TASK_REVISION_APP)

echo Waiting for service stable...
aws --profile $PROJECT_NAME ecs wait services-stable --cluster $PROJECT_NAME-main --services $PROJECT_NAME-web-$APP_ENV-app

echo Reset AWS json files
git checkout HEAD -- aws/task-definition-app.json
git checkout HEAD -- aws/task-definition-migrate.json
git checkout HEAD -- aws/run-task-migrate.json

echo Complete
