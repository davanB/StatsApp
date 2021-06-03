#!/bin/sh

# Docker entrypoint script.
# Wait until Postgres is ready before running the next step.

while ! pg_isready -q -h $DATABASE_HOST -p $DATABASE_PORT -U $DATABASE_USER
do
  echo "$(date) - waiting for database to start."
  sleep 2
done

echo "Creating $DATABASE_NAME"
mix ecto.create
echo "Database $DATABASE_NAME exists, running migrations..."
mix ecto.migrate
mix run priv/repo/seeds.exs
echo "Migrations finished."

# Start the server.
mix phx.server