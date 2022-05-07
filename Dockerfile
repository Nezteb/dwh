FROM elixir:1.11.4

RUN apt-get update && apt-get install -y postgresql-client

# Create app directory and copy the Elixir projects into it
RUN mkdir /appf
WORKDIR /app

# Install hex package manager
RUN mix local.hex --force
RUN mix local.rebar --force

COPY ./mix.exs /app/mix.exs
COPY ./mix.lock /app/mix.lock
COPY ./priv /app/priv
COPY ./test /app/test
COPY ./config /app/config
COPY ./lib /app/lib

# Compile the project
RUN mix do deps.get, compile, release

# Entrypoint script
COPY ./entrypoint.sh /app/entrypoint.sh
RUN chmod +x /app/entrypoint.sh

ENTRYPOINT ["/app/entrypoint.sh"]
