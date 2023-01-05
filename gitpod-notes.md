### Set up
1. Fork https://github.com/eclipse-pass/pass-docker
1. Clone your fork locally
1. Create a local branch for your work.
1. Install Docker on your machine if you don't already have it.
1. Install docker-machine?
1. Create a `hosts` file entry that aliases the hostname `pass.local` to your loopback address (`127.0.0.1`).
1. To determine your docker-machine address, `docker-machine ip default`
1. While the PASS app will start by navigating to `127.0.0.1` or e.g. `192.168.99.100`, the PASS application running as a local demo on your machine depends on the `pass.local` being defined. 

### Running Demo
1. Be sure Docker is running
1. Run `./demo.sh up -d && ./demo.sh logs -f` to bring up the local demo env
1. Wait until pass-core shows a log message saying that it has started up:
```
    [main] [Pass, ] INFO org.eclipse.pass.main.Main.logStarted - Started Main in 8.677 seconds (JVM running for 9.406) At this point, pass-core has initialized the DB.
```
1. You can ignore these warning messages:
```
WARN[0000] The "EMBER_GIT_REPO" variable is not set. Defaulting to a blank string. 
WARN[0000] The "METADATA_SCHEMA_URI" variable is not set. Defaulting to a blank string. 
WARN[0000] The "EMBER_GIT_BRANCH" variable is not set. Defaulting to a blank string. 
```
1. This error shows up occasionally:
```
failed to solve: rpc error: code = Unknown desc = failed to solve with frontend dockerfile.v0: failed to read dockerfile: open /var/lib/docker/tmp/buildkit-mount2714819657/Dockerfile: no such file or directory
```
1. If you experience this error, run `./demo.sh pull` to make sure you have all the images downloaded, then retry `./demo.sh up -d && ./demo.sh logs -f `

1. Once pass-core shows it's up and running, run `./demo.sh up loader` to (re)run the sample data loader, which should succeed and exit with code 0

1. Your system should be operational. In your browser, navigate to https://pass.local. You can ignore the security warnings. They're because...

1. Login and poke around the PASS UI. See https://github.com/eclipse-pass/pass-docker#shibboleth-users for different personnae login options. Currently only credentials `nih-user/moo` are running in this demo.

### Shutting down the demo
1. To stop the demo, `./demo.sh down`
1. Again, you can ignore these error messages:
```
WARN[0000] The "METADATA_SCHEMA_URI" variable is not set. Defaulting to a blank string. 
WARN[0000] The "EMBER_GIT_REPO" variable is not set. Defaulting to a blank string. 
WARN[0000] The "EMBER_GIT_BRANCH" variable is not set. Defaulting to a blank string. 
```
