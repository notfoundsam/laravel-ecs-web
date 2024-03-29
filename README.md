## About project

Base template for EC and similar websites. Template based on Laravel framework and set up to run on AWS ESC. For local development it needs Docker, Docker Compose and Make.
The project can be deployed from local machine or via GitLab. The infrastructure of this project can be created with related project on [GitHub](https://github.com/notfoundsam/laravel-ecs-terraform)

### Requirements

- An AWS account with created infrastructure
- Docker
- Docker Compose
- Make
- sed
- GitLab account (deploy via GitLab)
- macOS or Linux

### Docker images configuration

- php 8.0.3-fpm based on alpine 3.13
- nginx 1.19.4 based on alpine latest
- xdebug 3.0.4 (local development only)

### Project configuration

- [Laravel 8.x](https://laravel.com/)
- [UIkit 3.6.x](https://getuikit.com/)
- [VueJS 2.6.x](https://vuejs.org/)
- Email catcher [MailDev](http://maildev.github.io/maildev/) (local development only)
- [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2-docker.html) v2 in docker container

### Xdebug configuration

- Xdebug mode `develop,debug,trace,profile`.
- Xdebug profiler output `./storage/xdebug`.
- Xdebug profiler output name `cachegrind.%t`.
- Xdebug start_with_request `trigger`. You can use [Xdebug helper](https://chrome.google.com/webstore/detail/xdebug-helper/eadndfjplgieldjbigjakmdgkmoaaaoc) for Chrome.
- Xdebug client_host passes from `RHOST` variable in Makefile.

### Local development

1. Build a docker image with the following commands `make build`
2. Run the project `make up`
3. Run the migration script `make migrate`
4. Access to `http://localhost:9010` to watch web pages
5. Access to `http://localhost:9010/admin/login` to login to Admin's pages
6. Access to `http://localhost:9010/partner/login` to login to Partner's pages
7. Run Yarn watch script `make watch`

### Prepare to deploy from a local machine
1. In `./Makefile` replace `AWS_PROFILE` `AWS_REGION_NAME` `AWS_ACCOUNT_ID` `CLUSTER_NAME` `PROJECT_NAME` with yours.
2. On AWS create a new policy `AWSClusterDeployPolicy` with content from `./aws/AWSClusterDeployPolicy.json`
3. Create a new user `MyECSDeployUser`. Attach two policies `AmazonEC2ContainerRegistryFullAccess` and policy from step 2 to the user. Save your credentials.
4. Run `make aws-setup` and set up your awscli. (access key, region etc.)
5. In `.aws/run-task-migrate.json`replace `securityGroups` and `subnets` to yours. Commit these changes. (migrate the app on AWS Fargate)

### Deploy to production from a local machine
Run `make deploy-prod-`. At first, it will migrate your database in ECS Fargate then run the deployment.

### Rolling back production DB from a local machine
1. Checkout a commit to roll back.
2. Run `make rollback-db-prod` [IN PROGRESS]

### Prepare to deploy via GitLab
Coming soon... (see .gitlab-ci.yml)
