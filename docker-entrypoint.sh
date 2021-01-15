#!/bin/sh
RABBITMQ_TCP=$(echo $RABBITMQ_URL | sed -E "s/amqp:\/\/.+@/tcp:\/\//")
POSTGRES_TCP=$(echo $POSTGRES_URL | sed -E "s/postgres:\/\/.+@/tcp:\/\//")
REDIS_TCP=$(echo $REDIS_URL | sed -E "s/rediss?:\/\/(.*@)?/tcp:\/\//")

export DATABASE_URL=$POSTGRES_URL

dockerize -wait $POSTGRES_TCP \
          -wait $RABBITMQ_TCP \
          -wait $REDIS_TCP \
          -timeout 20s

if [ "$1" = "test" ]; then
  export ENV='test'
  set -e
  bundle exec hanami db prepare
  exec bundle exec rake
elif [ "$1" = "worker" ]; then
  export ENV='development'
  export HANAMI_ENV='development'
  PGPASSWORD=postgres createdb --host=postgres -w cloud-importer-test --user=postgres
  PGPASSWORD=postgres bundle exec hanami db migrate

  set -e
  bundle exec ruby ./bin/refresh_players
elif [ "$1" = "run" ]; then
  export ENV='development'
  export HANAMI_ENV='development'
  PGPASSWORD=postgres createdb --host=postgres -w cloud-importer-test --user=postgres
  PGPASSWORD=postgres bundle exec hanami db migrate
  set -e

  exec bundle exec puma -p 8080
else
  exec "$@"
fi
