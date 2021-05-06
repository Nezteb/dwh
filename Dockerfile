FROM elixir:1.11.4

RUN apt-get update && apt-get install -y postgresql-client

# Create app directory and copy the Elixir projects into it
RUN mkdir /app
COPY . /app
WORKDIR /app
RUN chmod +x /app/entrypoint.sh

# Install hex package manager
RUN mix local.hex --force
RUN mix local.rebar --force

# Compile the project (for both dev and test, for faster container startup)
RUN MIX_ENV=test mix deps.get
RUN MIX_ENV=test mix do compile
RUN mix deps.get
RUN mix do compile

ENTRYPOINT ["/app/entrypoint.sh"]
