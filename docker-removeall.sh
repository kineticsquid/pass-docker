#!/usr/bin/env bash
# Description:
#   Prepare Docker for a fresh start, removing most everything:
#     all composer projects, containers and anonymous volumes
#     all non-composer containers
#     all images, etc. per docker system prune ...

MAX_WAIT=45  # Max time to wait for compose project to exit
EACH_WAIT=5  # Sleep time between iterations of waiting for compose project to exit

ENV=/usr/bin/env
DOCKER="$ENV docker"
TIMEOUT_MINIMAL=1

# Case-insensitive regex matching:
shopt -s nocasematch

# Currently "Docker Desktop" bundles compose as part of docker.
# Earlier distributions, including those on servers, would likely require
# that docker-compose be installed.  Find which we have... and if not found
# then we will avoid any compose-based cleanup but still prune docker, etc.
COMPOSE=""
for i in 'docker compose' docker-compose ; do
  ver=$( $i version 2> /dev/null )
  if [ 0 -eq $? ] && [[ "$ver" =~ compose.*version ]] ; then
    COMPOSE="$i"
    break
  fi
done

function shutdownCompose() {
  # Arguments:
  #   none
  # Description: 
  #   Trigger stopping docker compose projects similar to if ^C were typed at the console.
  #   Wait up to (GLOBAL) "MAX_WAIT" seconds for stop
  local pids pid
  local waitCount=10
  local notDone=1
  local now=$( date +%s )
  local untilTime=$(( now + MAX_WAIT ))

  # Find process IDs associated with docker compose parent processes running
  pids=$( pgrep 'docker.*compose' )
  # For each such pid found, loop through and try to kill nicely each docker compose project
  if [ -n "$pids" ] ; then
    for pid in $pids ; do
      printf "Attempting docker compose termination for running projects\n"
      kill -TERM $pid
      waitCount=5
    
      while [ 1 == "$notDone" ] ; do
        sleep $EACH_WAIT
        printf "...(still) waiting for processes to stop\n"
        pids=$( pgrep 'docker.*compose' | grep "$pid" )

        if [ -z "$pids" ] || [ $(date +%s) -gt $untilTime ] ; then
          notDone=0
        fi
      done
    done

    # If any remaining docker compose PIDs still running, forcefully kill them and move on:
    pids=$( pgrep 'docker.*compose' )
    if [ -n "$pids" ] ; then
      printf "Max wait time reached\n...force-killing stubborn docker-container pid(s): $pids\n"
      kill -KILL $pids
    fi
  fi
}

function dockerInventory() {
  # Arguments:
  #   none
  # Description:
  #   Output a record of Docker compose projects, Docker containers, images, etc.
  local seperator="---------"
  printf "\n\n==== Current Docker Inventory ====\n"

  if [ -n "$COMPOSE" ] ; then
    printf "\nDocker compose projects:\n"
    $COMPOSE ls
    printf "%s\n" $seperator
  fi

  printf "\nContainers:\n"
  $DOCKER ps --all
  printf "%s\n" $seperator

  printf "\nImages:\n"
  $DOCKER images -a

  printf "\n========\n\n"
}

function dockerRemoveComposeProjects() {
  # Arguments:
  #   none
  # Description:
  #   performs following operations on each docker compose project:
  #     stop
  #     kill
  #     rm
  local composeProject
  local composeProjects=$( $COMPOSE ls --all --format json | jq -r .[].Name )
  if [ -z "$composeProjects" ] ; then
    printf "No docker compose projects found\n"
  else
    for composeProject in $composeProjects ; do

      for action in stop kill ; do
        printf "Action: '$action' on docker compose service: '%s'\n" $composeProject
        $COMPOSE $action  $composeProject  --timeout=$TIMEOUT_MINIMAL
      done

      printf "Removing docker compose service and anonymous volumes: '%s'\n" $composeProject
      $COMPOSE rm --stop --volumes --force "$composeProject" --timeout=1
    done
  fi
  printf "  done with docker compose project cleanup\n"
}

function dockerRemoveContainers() {
  # Arguments:
  #   none
  # Description:
  #   removes any still-running containers as well as stopped containers
  local cId cName
  printf "Docker container cleanup\n"
  $DOCKER ps --all --format '{{.ID}}{{" "}}{{.Names}}' | while read cId cName ; do
    printf "  removing individual container: '%s' (%s): " $cName $cId
    $DOCKER rm -f "$cId"
  done
  printf "  done with docker container cleanup\n"
}

function dockerPrune() {
  # Arguments:
  #   none
  # Description:
  #   removes docker images and any residue
  printf "Performing full docker system prune\n"
  $DOCKER system prune --all --force
  printf "  done with docker system prune\n"
}

date
dockerInventory

if [ -n "$COMPOSE" ] ; then
  printf "Using COMPOSE='$COMPOSE'\n"
  dockerRemoveComposeProjects
  shutdownCompose
else
  printf "Could not identify docker-compose (or docker with compose)...\n"
  printf "  skipping docker-compose cleanup bits!\n\n"
  exit -1
fi

dockerRemoveContainers
dockerPrune

dockerInventory
date

exit 0
