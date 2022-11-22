#!/usr/bin/env bash
# Description:
#   Stop all running containers

ENV=/usr/bin/env
DOCKER="$ENV docker"

for pid in $($DOCKER ps --quiet) ; do
  printf "Stopping docker container $pid ..."
  $DOCKER stop $pid > /dev/null 2>&1
  printf " done.\n"
done

exit 0
