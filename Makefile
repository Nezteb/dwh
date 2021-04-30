.DEFAULT_GOAL := docker

### Docker Development Commands

.PHONY: docker
docker: down
	# You may want to rebuild the Docker container with "make build" before this
	docker-compose up --detach --renew-anon-volumes
	# Once the container is up, you can start a shell using `make dev` or `make test`

.PHONY: web
web:
	docker-compose exec web "bash"
	# After you have a shell, you can use `iex -S mix phx.server`

.PHONY: test
test:
	docker-compose exec test "bash"
	# After you have a shell, you can use `mix test`

.PHONY: down
down:
	docker-compose down --remove-orphans

.PHONY: build
build:
	docker-compose build

.PHONY: stop
stop: down
	docker stop $(docker ps -aq) || true
	docker rm $(docker ps -aq) || true

.PHONY: dozzle
dozzle: dozzle-stop
	docker run --name dozzle -d --volume=/var/run/docker.sock:/var/run/docker.sock -p 9999:8080 amir20/dozzle:latest || true
	open http://localhost:9999

.PHONY: dozzle-stop
dozzle-stop:
	docker stop dozzle || true
	docker rm dozzle || true

### Local Development Commands

.PHONY: clean
clean:
	mix clean --deps
	mix deps.clean --all

.PHONY: setup
setup: build
	# This only needs to be run once
	mix deps.get
	mix ecto.create