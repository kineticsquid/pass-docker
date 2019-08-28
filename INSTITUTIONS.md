# Institution Support

PASS supports multiple institutions.  Each institution receives its own docker compose and environment file.

> When starting, stopping, or otherwise administering docker containers, it is important to specify the docker compose file to work with, using the `-f` option of the `docker-compose` command.

> Note that `docker-compose` reads the `.env` file automatically, regardless of the docker-compose file passed by `-f`.  This is a gotcha if you specify variables in the build arguments of a service: don't do that. 

A couple of different patterns are used to support multiple institutions when building images:
- the use of a `TENANT` build argument
    - an image exists for each institution as specified by the `TENANT`
    - e.g. the `idp`, `sp`, `ldap` images     
- including configuration files for supported institutions in the image
    - a single image exists for all institutions, and the configuration for an institution is specified at runtime
    - `index` (via `PI_ES_CONFIG`), `schemaservice` (via `METADATA_SCHEMA_URI`), `policyservice` (via `POLICY_FILE`)

## Johns Hopkins

Uses the default `docker-compose.yml` and `.env` files.

Launch using `docker-compose up -d`.

## Harvard

Uses the `harvard.yml` and `.harvard_env` files.

Launch using `docker-compose -f harvard.yml up -d`.

