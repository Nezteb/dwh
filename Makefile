.DEFAULT_GOAL := docker

### Docker Development Commands

.PHONY: docker
docker: down build
	docker compose up --detach --renew-anon-volumes
	# Once the container is up, it will start the server on its own
	# You can run tests with `make test`
	# You can also start a shell using `make shell`

.PHONY: test
test:
	docker compose exec web mix test

.PHONY: shell
shell:
	# After you have a shell, you can use `iex -S mix run --no-start` or `mix test`
	docker compose exec web bash

.PHONY: down
down:
	docker compose down --remove-orphans

.PHONY: build
build:
	docker compose build

.PHONY: stop
stop: down
	docker stop $(docker ps -aq) 2>/dev/null || true
	docker rm $(docker ps -aq) 2>/dev/null || true

.PHONY: dozzle
dozzle: dozzle-stop
	# Open http://localhost:9999 to access Dozzle
	docker run --name dozzle -d --volume=/var/run/docker.sock:/var/run/docker.sock -p 9999:8080 amir20/dozzle:latest || true

.PHONY: dozzle-stop
dozzle-stop:
	docker stop dozzle 2>/dev/null || true
	docker rm dozzle 2>/dev/null || true

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
