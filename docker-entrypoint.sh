#!/bin/bash
set -e
echo "ENTRYPOINT: Starting docker entrypoint ..."
echo "running database migrations"
bundle exec rake db:migrate
echo "ENTRYPOINT: Finished docker entrypoint."
exec "$@"
