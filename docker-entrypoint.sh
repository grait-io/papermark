#!/bin/sh

# Exit on error
set -e

# Check if we're in Coolify environment (no local postgres container)
if [ -n "$DATABASE_URL" ]; then
  echo "Using external database from DATABASE_URL"
else
  echo "Waiting for database to be ready..."
  # Wait for PostgreSQL to be ready
  while ! nc -z postgres 5432; do
    sleep 1
  done
  echo "Database is ready!"
fi

# Run database migrations
echo "Running database migrations..."
npx prisma migrate deploy --schema=./prisma/schema/schema.prisma

# Start the application
echo "Starting Papermark application..."
exec "$@"