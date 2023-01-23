#!/bin/bash

# Example running:
# ./demo.sh up -d --quiet-pull --no-build

# .env file(s) specified in docker-compose files
# Some images need a .env file specified here or else will throw an error
# The base .env is sufficient for those, while the .env files specified in
# the various compose files work at runtime
docker compose --env-file .env -f docker-compose.yml -f eclipse-pass.local.yml $@