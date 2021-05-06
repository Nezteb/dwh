.DEFAULT_GOAL := docker

### Docker Development Commands

.PHONY: docker
docker: down
	# You may want to rebuild the Docker container with "make build" before this
	docker-compose up --detach --renew-anon-volumes
	# Once the container is up, you can run the server with `make web` or tests with `make test`
	# You can also start a shell using either `make shell-web` or `make shell-test`

.PHONY: web
web:
	docker-compose exec web mix phx.server

.PHONY: test
test:
	docker-compose exec test mix test

.PHONY: shell-web
shell-web:
	# After you have a shell, you can use `iex -S mix phx.server`
	docker-compose exec web bash

.PHONY: shell-test
shell-test:
	# After you have a shell, you can use `mix test`
	docker-compose exec test bash

.PHONY: down
down:
	docker-compose down --remove-orphans

.PHONY: build
build:
	docker-compose build

.PHONY: stop
stop: down
	docker stop `docker ps -aq` || true
	docker rm `docker ps -aq` || true

.PHONY: dozzle
dozzle: dozzle-stop
	# Open http://localhost:9999 to access Dozzle
	docker run --name dozzle -d --volume=/var/run/docker.sock:/var/run/docker.sock -p 9999:8080 amir20/dozzle:latest || true

.PHONY: dozzle-stop
dozzle-stop:
	docker stop dozzle || true
	docker rm dozzle || true

### Local Development Commands (or for use in your container)

.PHONY: format
format:
	mix format mix.exs "lib/**/*.{ex,exs}" "test/**/*.{ex,exs}"

.PHONY: lint
lint:
	mix dialyzer

.PHONY: clean
clean:
	mix clean --deps
	mix deps.clean --all

.PHONY: setup
setup: clean
	# This only needs to be run once
	mix deps.get
	mix ecto.create
	mix ecto.migrate
