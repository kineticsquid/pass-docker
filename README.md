# Instructions

## Building

1. Check out this repository
2. `cd` into `pass-demo-docker`
  - Peek at `.env` and change any values you wish.  The defaults should work, but if you encounter port conflicts, you may want to change the values of:
      - PY_GGI_PORT
      - FTP_SUBMISSION_DEBUG_PORT
      - FTP_SERVER_PORT
  - The FTP submission code base will be downloaded and built from `SUBMISSION_GIT_REPO`, using the branch or tag defined in `SUBMISSION_GIT_BRANCH` 
3. Run `docker-compose build`
  - Lots of things should fly across, including the Maven build of the FTP submission code
  
## Starting  
1. Run `docker-compose up`

## Stopping
1. Type `CTRL-C`
1. Optionally, run `docker-compose down`

# Trigger a Submission
1. Start the demo
  - `docker-compose up`
2. Send an empty HTTP `POST` request to the submission container, by default port `8080` or whatever `PY_CGI_PORT` is defined as
  - for `docker-machine` users, this will be an IP address like `192.168.99.100`
  - for `Docker for *` users, this will be `localhost`   

You should see some logs flow across your Docker terminal window, and an indication of a successful FTP upload.

 
