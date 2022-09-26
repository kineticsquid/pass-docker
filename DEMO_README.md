The "demo" compose file describes an early system meant to demonstrate some new technologies and services in PASS. In its current state, several services rely on local images not yet published.

## Running:

Docker compose works as normal, but for the demo you need to specify both correct `yml` file and env file:

``` sh
docker-compose -f demo.yml --env-file=.demo_env up -d
```

`./demo.sh` is a convenience script that runs `docker-compose` with the right compose and environment files. The following will do the same as above:

``` sh
./demo.sh up -d
```

If you want to tail the `proxy` logs, for example, run `./demo.sh logs -f proxy`

Setting up an alias would perform the same function. 

## Services:

### `auth`

[pass-auth](https://github.com/jaredgalanis/pass-auth) - currently in an early dev state, this service is currently configured to serve as a drop-in replacement of the old `sp` image. It provides authorization mechanisms to secure routes. Because of this, it also acts as a reverse proxy, ensuring the configured routes are protected appropriately.

This early state uses a naive 'local' auth strategy, with a pre-configured password to authenticate by. Users that "login" must provide a valid username that matches a User email address from the Elide `User` table.

### `elide`

Semi-custom [pass-elide-test](https://github.com/jabrah/pass-elide-test/tree/enable-links) (`#enable-links` branch). This requires a new local build at the moment. This services provides PASS' data APIs. A Swagger page is available at `/swagger` once authenticated, which may no longer function correctly in the docker-compose environment, but will still describe the API capabilities.

### `postgres`

Pretty much an out-of-the-box PostgreSQL server. Only interacts with the `elide` service

### `proxy`

Custom Apache server, copied from the previous non-demo environments top level proxy. Has a self-signed cert for pseudo "https" support. We should consider removing this in favor of simply exposing the `auth` service, since this proxy basically just forwards everything to `auth` anyway. This would require a more production-ready and robust `auth` service that handles https correctly and is easier to configure.

### `loader`

A bootstrap service that will dump a small set of testing data through the Elide endpoints. This will occur when the loader container starts up and shuts down when done. This service is commented out in `demo.yml` at the moment, since the data will persist in the postgres volume between docker environment restarts. If the volume is destroyed or otherwise not present, you can uncomment this service to run it.

*This service should be removed or otherwise not be used when the "real" test assets is available.*

### Images that must be built locally:

* `auth`
* `elide`
* `proxy`
* `loader`

TODO: Submit PRs where necessary, publish ready images to GHCR

