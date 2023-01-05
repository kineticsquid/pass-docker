#!/bin/bash

docker-compose -f gitpod-demo.yml --env-file .eclipse-pass.gitpod_env $@