#!/bin/bash

docker-compose -f gitpod-demo.yml --env-file .demo_env $@