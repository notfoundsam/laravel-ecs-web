UID=$(id -u):$(id -g)
RHOST='192.168.100.101'
DCF='docker-compose.yml'

AWS_PROFILE='notfoundsam'

ALL: info
info:
	@echo "[web]   http://localhost:9010"
	@echo "[bsync] http://localhost:9011"
	@echo "[email] http://localhost:1010"
	@echo "[db]    http://localhost:3310"
aws-setup:
	pip3 install --upgrade awscli
	aws configure --profile $(AWS_PROFILE)
build-linux:
	CURRENT_UID=$(value UID) docker-compose -f $(DCF) build
	CURRENT_UID=$(value UID) docker-compose -f $(DCF) run --rm composer
	CURRENT_UID=$(value UID) docker-compose -f $(DCF) run --rm composer composer run-script post-root-package-install
	CURRENT_UID=$(value UID) docker-compose -f $(DCF) run --rm composer composer run-script post-create-project-cmd
	CURRENT_UID=$(value UID) docker-compose -f $(DCF) run --rm node yarn
build-mac:
	docker-compose -f $(DCF) build
	docker-compose -f $(DCF) run --rm composer
	docker-compose -f $(DCF) run --rm composer composer run-script post-root-package-install
	docker-compose -f $(DCF) run --rm composer composer run-script post-create-project-cmd
	docker-compose -f $(DCF) run --rm node yarn
up-linux:
	CURRENT_UID=$(value UID) REMOTE_HOST=$(value RHOST) docker-compose -f $(DCF) up -d
	make info
up-mac:
	REMOTE_HOST=host.docker.internal docker-compose -f $(DCF) up -d
	make info
stop:
	docker-compose -f $(DCF) stop
migrate:
	docker-compose -f $(DCF) exec php-fpm php artisan migrate
rollback:
	docker-compose -f $(DCF) exec php-fpm php artisan migrate:rollback
autoload:
	docker-compose -f $(DCF) exec php-fpm composer dump-autoload
refresh:
	docker-compose -f $(DCF) exec php-fpm php artisan migrate:refresh --seed
truncate:
	docker-compose -f $(DCF) exec php-fpm php artisan migrate:refresh
console:
	docker-compose -f $(DCF) exec php-fpm php artisan tinker
clear:
	docker-compose -f $(DCF) exec php-fpm php artisan cache:clear
	docker-compose -f $(DCF) exec php-fpm php artisan route:cache
route:
	docker-compose -f $(DCF) exec php-fpm php artisan route:list
sh-php:
	docker-compose -f $(DCF) exec php-fpm sh
watch-linux:
	CURRENT_UID=$(value UID) docker-compose -f $(DCF) run --rm node yarn
	CURRENT_UID=$(value UID) docker-compose -f $(DCF) run --rm node yarn watch
watch-mac:
	docker-compose -f $(DCF) run --rm node yarn
	docker-compose -f $(DCF) run --rm node yarn watch
deploy-prod-mac:
	docker-compose -f $(DCF) run --rm composer
	docker-compose -f $(DCF) run --rm node yarn prod
	./aws/release-production.sh mac
deploy-prod-linux:
	CURRENT_UID=$(value UID) docker-compose -f $(DCF) run --rm composer
	CURRENT_UID=$(value UID) docker-compose -f $(DCF) run --rm node yarn prod
	./aws/release-production.sh linux
deploy-prod-mac:
	docker-compose -f $(DCF) run --rm composer
	docker-compose -f $(DCF) run --rm node yarn prod
	./aws/release-production.sh mac
rollback-db-prod-linux:
	./aws/rollback-db-production.sh linux
rollback-db-prod-mac:
	./aws/rollback-db-production.sh mac