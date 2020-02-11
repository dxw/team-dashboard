#!/bin/bash
set -e

echo "ENTRYPOINT: Starting docker entrypoint ..."

echo "ENTRYPOINT: Finished docker entrypoint."
exec "$@"
