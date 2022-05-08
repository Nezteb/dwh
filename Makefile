.DEFAULT_GOAL := docker

### Docker Development Commands

.PHONY: docker
docker: down build
	docker compose up --detach --renew-anon-volumes

.PHONY: down
down:
	docker compose down --remove-orphans

.PHONY: build
build:
	docker compose build --progress=plain --build-arg MIX_ENV=${MIX_ENV}

.PHONY: stop
stop: down
	docker stop $(docker ps -aq) 2>/dev/null || true
	docker rm $(docker ps -aq) 2>/dev/null || true

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
	mix setup
