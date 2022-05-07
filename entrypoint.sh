#!/bin/bash
# Docker entrypoint script.
elixir -v
export PGPASSWORD=$POSTGRES_PASSWORD # For non-interactive psql commands

env | sort

# Wait until Postgres is ready
while ! pg_isready -q -h "$POSTGRES_HOST" -p 5432 -U "$POSTGRES_USER"
do
  pg_isready -h "$POSTGRES_HOST" -p 5432 -U "$POSTGRES_USER"
  echo "$(date) - waiting for database to start..."
  sleep 2
done

echo "Connected to database host $POSTGRES_HOST"

# Create, migrate, and seed database if it doesn't exist.
if [[ -z $(psql -h "$POSTGRES_HOST" -p 5432 -U "$POSTGRES_USER" -Atqc "\\list $POSTGRES_DATABASE") ]]; then
  echo "Database $POSTGRES_DATABASE does not exist; creating..."
  mix ecto.create
  mix ecto.migrate

  # Don't seed the test database
  if [ "$MIX_ENV" != "test" ]; then
    mix run priv/repo/seeds.exs
  fi

  echo "Database $POSTGRES_DATABASE created"
else
  echo "Database $POSTGRES_DATABASE already exists"
fi

mix do deps.get, phx.server