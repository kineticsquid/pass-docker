## Notes
- Updated `readme.md` to add a link to open a gitpod workspace.
- Created `.gitpod.yml` with to initialize and start the server. This updates `/etc/hosts` to point `pass.local` to `127.0.0.1`.
- Copied `eclipse-pass.nightly.yml` to `eclipse-pass.gitpod.yml` and made the following changes:
```
     - IDP_HOST=https://82-kineticsquid-passdocker-1hlkn7c98uj.ws-us81.gitpod.io
```
- Copied `eclipse-pass.nightly_env` to `eclipse-pass.gitpod_env` and made the following changes:
```
tbd
```

## Running in gitpod
``` sh
docker compose -f docker-compose.yml -f eclipse-pass.gitpod.yml up
docker compose -f docker-compose.yml -f eclipse-pass.gitpod.yml logs
```

If you want to tail the `proxy` logs, for example, run `./gitpod-demo.sh logs -f proxy`

## Running Locally
``` sh
docker compose -f docker-compose.yml -f eclipse-pass.local.yml up
docker compose -f docker-compose.yml -f eclipse-pass.local.yml logs
```


## Terminating
``` sh
docker compose down
```

## Update images
``` sh
docker compose pull
```