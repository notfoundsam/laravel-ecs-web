#!/bin/bash

OS=$1
PROJECT_NAME=$2
AWS_REGION_NAME=$3
AWS_ACCOUNT_ID=$4

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
echo Rolling DB back version:$VERSION

echo Replace AWS json files
git checkout HEAD -- aws/task-definition-migrate.json
sed -i $SED_BACK -e 's/app_environment/production/g; s/app_version/'$VERSION'/g; s/project_name/'$PROJECT_NAME'/g; s/region_name/'$AWS_REGION_NAME'/g; s/account_id/'$AWS_ACCOUNT_ID'/g; s/db_command/migrate:rollback/g;' aws/task-definition-migrate.json

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

echo Reset AWS json files
git checkout HEAD -- aws/task-definition-migrate.json
git checkout HEAD -- aws/run-task-migrate.json

echo Complete
