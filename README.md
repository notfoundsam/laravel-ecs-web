## About project

Скелет приложения для B2C и подобных сервисов. Основан на php фреймворке Laravel и настроен для запуска в AWS ESC. Локальный запуск требует наличия Docker и Make.
Деплоймент может быть запущен как с локальной машины, так и через GitLab.

### Docker images configuration

- php 7.4.12-fpm based on alpine 3.12
- nginx 1.19.4 based on alpine latest
- xdebug 2.9.8 (development only)

### Project configuration

- [Laravel 8.x](https://laravel.com/)
- [UIkit 3.6.x](https://getuikit.com/)
- [VueJS 2.6.x](https://vuejs.org/)
- Email catcher [MailDev](http://maildev.github.io/maildev/)

### Local development

1. Build a docker image with the following commands `make build-linux` or `make build-mac`
2. Run the project `make up-linux` or `make up-mac`
3. Run the migration script `make migrate`
4. Access to `http://localhost:9010` to watch web pages
5. Access to `http://localhost:9010/admin/login` to login to Admin's pages
6. Access to `http://localhost:9010/partner/login` to login to Partner's pages
7. Run Yarn watch script `make watch-linux` or `make watch-mac`

### Deploy to production
Run `make deploy-prod-linux` or `make deploy-prod-mac`. At first, it will migrate your database in ECS Fargate then run the deployment.

### Rolling back production DB
1. Checkout a commit to roll back.
2. Run `make rollback-db-prod-linux` or `make rollback-db-prod-mac`
