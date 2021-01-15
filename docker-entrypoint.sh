#!/bin/sh
RABBITMQ_TCP=$(echo $RABBITMQ_URL | sed -E "s/amqp:\/\/.+@/tcp:\/\//")
POSTGRES_TCP=$(echo $POSTGRES_URL | sed -E "s/postgres:\/\/.+@/tcp:\/\//")
REDIS_TCP=$(echo $REDIS_URL | sed -E "s/rediss?:\/\/(.*@)?/tcp:\/\//")

DATABASE_URL=$POSTGRES_URL

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
  export ENV='production'
  bundle exec hanami db prepare

  bundle exec ./bin/refresh_players
elif [ "$1" = "run" ]; then
  export ENV='production'
  bundle exec hanami db prepare
  set -e

  exec bundle exec ./bin/cloud-importer
else
  exec "$@"
fi
