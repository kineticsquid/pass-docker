#!/bin/bash

# Example running:
# ./demo.sh up -d --quiet-pull --no-build --wait

# .env file(s) specified in docker-compose files
docker compose -f eclipse-pass.base.yml -f eclipse-pass.local.yml $@