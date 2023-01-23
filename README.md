The "demo" compose file describes an early system meant to demonstrate some new technologies and services in PASS. 

## Running:

Docker compose works as normal, but for the demo you need to specify both correct `yml` file and env file. In order to run a local instance, you can run:

``` sh
docker compose up -d --no-build
```

## Services:

### [`pass-auth`](https://github.com/jaredgalanis/pass-auth)

Repository: https://github.com/jaredgalanis/pass-auth
Package: https://github.com/orgs/eclipse-pass/packages/container/package/pass-auth

Provides authorization mechanisms to secure routes. It also acts as a reverse proxy, ensuring the configured routes are protected appropriately.

Node based authentication service that currently integrates SAML authentication workflow in the demo environment.

Environment variables:

* `PASS_CORE_API_URL=http://pass-core:8080/`
* `PASS_CORE_NAMESPACE=data/`
* `PASS_UI_URL=http://pass-ui:81/`
* `PASSPORT_STRATEGY="multiSaml"`
* `NODE_ENV="development"`
* `AUTH_PORT=3000`
* `AUTH_LOGIN="/login/:idpId"`
* `AUTH_LOGIN_SUCCESS=/app/auth-callback`
* `AUTH_LOGIN_FAILURE=/`
* `AUTH_LOGOUT=/logout`
* `AUTH_LOGOUT_REDIRECT=/`
* `FORCE_AUTHN=true`
* `SIGNING_CERT_IDP="..."`
* `SAML_ENTRY_POINT="https://pass.local/idp/profile/SAML2/Redirect/SSO"` : absolute URL must change for different environments
* `SAML_ISSUER="https://sp.pass/shibboleth"`
* `ACS_URL="/Shibboleth.sso/SAML2/POST/:idpId"`
* `METADATA_URL="/metadata/:idpId"`
* `IDENTIFIER_FORMAT=""`
* `SESSION_SECRET="..."`

The following are absolute URLs on a docker compose private network, should not need to change in other environments
* `USER_SERVICE_URL="http://fcrepo:8080"`
* `ELASTIC_SEARCH_URL="http://elasticsearch:9200/pass/_search"`
* `SCHEMA_SERVICE_URL="http://schemaservice:8086"`
* `POLICY_SERVICE_URL="http://policyservice:8088"`
* `DOI_SERVICE_URL="http://doiservice:8080/"`
* `DOWNLOAD_SERVICE_URL="http://downloadservice:6502"`

### [`pass-core`](https://github.com/eclipse-pass/pass-core)

Repository: https://github.com/eclipse-pass/pass-core
Package: https://github.com/orgs/eclipse-pass/packages/container/package/pass-core-main

Presents a JSON:API window to the backend from behind the authentication layer. Swagger is not yet hooked up so is unreachable. Provides data and web APIs to the application.

Environment variables:

* `PASS_CORE_BASE_URL=https://pass.local` : Used when generating JSON API relationship links. Needs to be absolute and must change to match deployment environment
* `PASS_CORE_POSTGRES_PORT=5432`
* `PASS_CORE_API_PORT=8080`
* `POSTGRES_USER=postgres`
* `POSTGRES_PASSWORD=postgres`
* `JDBC_DATABASE_URL=jdbc:postgresql://postgres:5432/pass`
* `JDBC_DATABASE_USERNAME=pass`
* `JDBC_DATABASE_PASSWORD=moo`

### `postgres`

Pretty much an out-of-the-box PostgreSQL server. Only interacts with the [`pass-core`](https://github.com/eclipse-pass/pass-core) service.

### `proxy`

Repository: built out of this project
Package: https://github.com/orgs/eclipse-pass/packages/container/package/proxy

Custom Apache server, copied from the previous non-demo environments top level proxy. Has a self-signed cert for pseudo "https" support. We should consider removing this in favor of simply exposing the `auth` service, since this proxy basically just forwards everything to `auth` anyway. This would require a more production-ready and robust `auth` service that handles https correctly and is easier to configure.

### [`pass-ui`](https://github.com/eclipse-pass/pass-ui)

Repository: https://github.com/eclipse-pass/pass-ui
Package: https://github.com/orgs/eclipse-pass/packages/container/package/pass-ui

User interface for the PASS application. Currently does not handle environment variables nicely - they are baked into images at build time due. The environment variables in the demo environment should not need to be adjusted between different deployment environments.

Environment variables:

* `PASS_UI_PORT=81`
* `PASS_API_NAMESPACE=data`
* `PASS_UI_GIT_REPO=https://github.com/eclipse-pass/pass-ui`
* `PASS_UI_GIT_BRANCH=main`
* `PASS_UI_ROOT_URL=/app`
* `STATIC_CONFIG_URL=/app/config.json`
* `DOI_SERVICE_URL=/doiservice/journal`
* `MANUSCRIPT_SERVICE_LOOKUP_URL=/downloadservice/lookup`
* `MANUSCRIPT_SERVICE_DOWNLOAD_URL=/downloadservice/download`
* `POLICY_SERVICE_POLICY_ENDPOINT=/policyservice/policies`
* `POLICY_SERVICE_REPOSITORY_ENDPOINT=/policyservice/repositories`
* `SCHEMA_SERVICE_URL=/schemaservice`
* `USER_SERVICE_URL=/pass-user-service/whoami`

### `loader`

A basic Docker image where we can run a `curl` command to bootstrap the environment with data from `demo_data.json`

### `idp`, `ldap`

Other related images that work together with `pass-auth` to handle authentication. Based on services of the same name in the older `docker-compose` environment.

Environment variables:

* `MAIL_SMTP=11025`
* `MAIL_IMAPS=11993`
* `MAIL_MSP=11587`
* `OVERRIDE_HOSTNAME=mail.jhu.edu`
* `ENABLE_SPAMASSASSIN=0`
* `ENABLE_CLAMAV=0`
* `ENABLE_FAIL2BAN=0`
* `ENABLE_POSTGREY=0`
* `SMTP_ONLY=0`
* `ONE_DIR=1`
* `DMS_DEBUG=0`
* `ENABLE_LDAP=1`
* `TLS_LEVEL=intermediate`
* `LDAP_SERVER_HOST=ldap`
* `LDAP_SEARCH_BASE=ou=People,dc=pass`
* `LDAP_BIND_DN=cn=admin,dc=pass`
* `LDAP_BIND_PW=password`
* `LDAP_QUERY_FILTER_USER=(&(objectClass=posixAccount)(mail=%s))`
* `LDAP_QUERY_FILTER_GROUP=(&(objectClass=posixAccount)(mailGroupMember=%s))`
* `LDAP_QUERY_FILTER_ALIAS=(&(objectClass=posixAccount)(mailAlias=%s))`
* `LDAP_QUERY_FILTER_DOMAIN=(|(mail=*@%s)(mailalias=*@%s)(mailGroupMember=*@%s))`
* `ENABLE_SASLAUTHD=0`
* `POSTMASTER_ADDRESS=root`
* `SSL_TYPE=manual`
* `SSL_CERT_PATH=/tmp/docker-mailserver/cert.pem`
* `SSL_KEY_PATH=/tmp/docker-mailserver/key.rsa`

## Running Acceptance Tests

Repository: https://github.com/eclipse-pass/pass-acceptance-testing

There is a small set of end-to-end smoke tests that we can run against this environment for some validation of changes. These tests run automatically for new PRs that are opened against `main`, but can also be run locally. In order to do this, you'll first need to clone the repository with the tests.

Once you have the repository, wait for the Docker Compose environment to start up and initialize then run the tests directly. From the `pass-acceptance-testing` local repo, run:

``` sh
yarn            # Installs project dependencies
yarn run test   # Runs tests
```

