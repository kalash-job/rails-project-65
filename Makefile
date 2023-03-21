tests:
	bin/rails test

seed:
	bin/rails db:seed

setup:
	cp -n .env.example .env || true
	bin/rails db:migrate
	bin/rails db:seed

start:
	bin/rails server

lint:
	bundle exec rubocop
	bundle exec slim-lint app/views/

lint-fix:
	bundle exec rubocop -A

deploy:
	railway up

railway-logs:
	railway logs

railway-migrate:
	railway run bin/rails db:migrate

ci-setup:
	cp -n .env.example .env || true
	yarn install
	bundle install --without production development
	RAILS_ENV=test bin/rails db:prepare