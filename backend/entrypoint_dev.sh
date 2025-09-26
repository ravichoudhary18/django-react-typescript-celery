#!/bin/sh
set -e

# Only run migrations/collectstatic when starting Django server (web container)
if [ "$1" = "python" ] && [ "$3" = "manage.py" ] && [ "$4" = "runserver" ]; then
  echo "Running migrations..."
  python manage.py makemigrations --noinput || true
  python manage.py migrate --noinput

  echo "Creating static & media directories if not exist..."
  mkdir -p /mnt/static
  mkdir -p /mnt/media

  echo "Collecting static files..."
  python manage.py collectstatic --noinput
fi

echo "Starting: $@"
exec "$@"
