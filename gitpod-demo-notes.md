## Notes
- Updated `readme.md` to add a link to open a gitpod workspace.
- Created `.gitpod.yml` with to initialize and start the server. This updates `/etc/hosts` to point `pass.local` to `127.0.0.1`.
- Copied `demo.yml` to `gitpod-demo.yml` and made the following change in `gitpod-demo.yml`, specific to gitpod. 
```
     - IDP_HOST=https://82-kineticsquid-passdocker-1hlkn7c98uj.ws-us81.gitpod.io
```
- Copied `demo.sh` to `gitpod-demo.sh` and pointed it to `gitpod-demo.yml`.

## Running
``` sh
./gitpod-demo.sh up -d
./gitpod-demo.sh up -d && ./gitpod-demo.sh logs -f

```
If you want to tail the `proxy` logs, for example, run `./gitpod-demo.sh logs -f proxy`

## Terminating
``` sh
./gitpod-demo.sh down -d
```

## Update images
``` sh
./demo.sh pull -d
```