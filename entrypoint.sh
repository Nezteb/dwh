#!/bin/bash
# Docker entrypoint script.
elixir -v
export PGPASSWORD=$POSTGRES_PASSWORD # For non-interactive psql commands
env | sort

# Wait until Postgres is ready
while ! pg_isready -q -h $POSTGRES_HOST -p 5432 -U $POSTGRES_USER
do
  echo pg_isready -h $POSTGRES_HOST -p 5432 -U $POSTGRES_USER
  echo $(pg_isready -h $POSTGRES_HOST -p 5432 -U $POSTGRES_USER)
  echo "$(date) - waiting for database to start"
  sleep 2
done

# Create, migrate, and seed database if it doesn't exist.
if [[ -z `psql -h $POSTGRES_HOST -p 5432 -U $POSTGRES_USER -Atqc "\\list $POSTGRES_DATABASE"` ]]; then
  echo "Database $POSTGRES_DATABASE does not exist. Creating..."
  mix ecto.create
  mix ecto.migrate

  # Don't seed the test database
  if [ "$MIX_ENV" != "test" ]; then
    mix run priv/repo/seeds.exs
  fi

  echo "Database $POSTGRES_DATABASE created."
fi

# This creates an empty shell so that the Docker container stays alive for the user to start themselves
# Once they start a shell, they can run `mix phx.server` or `mix test` themselves
#iex
exec sh -c 'while true ; do wait ; done'
