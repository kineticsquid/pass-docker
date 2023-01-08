The "demo" compose file describes an early system meant to demonstrate some new technologies and services in PASS. In its current state, several services rely on local images not yet published.

## Running:

Docker compose works as normal, but for the demo you need to specify both correct `yml` file and env file:

``` sh
docker-compose -f gitpod-demo.yml --env-file .eclipse-pass.gitpod_env up -d
```

`./gitpod-demo.sh` is a convenience script that runs `docker-compose` with the right compose and environment files. The following will do the same as above:

``` sh
./gitpod-demo.sh up -d
```

If you want to tail the `proxy` logs, for example, run `./gitpod-demo.sh logs -f proxy`

Setting up an alias would perform the same function. 

## Terminating
``` sh
./gitpod-demo.sh down
```

## Update images
``` sh
./demo.sh pull
```