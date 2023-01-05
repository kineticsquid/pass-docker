#!/bin/bash

docker-compose -f gitpod.yml --env-file .eclipse-pass.gitpod_env $@