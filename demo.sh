#!/bin/bash

docker compose -f demo.yml --env-file .demo_env $@