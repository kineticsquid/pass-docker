#!/usr/bin/env python

# A simple HTTP server that responds to POSTs by running a shell command
# Usage: python cgi_server.py &

import os
import BaseHTTPServer
from subprocess import call

# Edit these values to control the server behavior
PORT    = os.environ['PY_CGI_PORT']
DEBUG_PORT = os.environ['FTP_SUBMISSION_DEBUG_PORT']
COMMAND = "java -jar /usr/local/src/nihms-submission/nihms-cli/target/nihms-cli-1.0.0-SNAPSHOT-shaded.jar"
ARGS    = "/usr/local/src/nihms-submission/nihms-cli/src/main/resources/FilesystemModelBuilderTest.properties local"

try:
    os.environ['PY_CGI_PORT']
except KeyError:
    print "Please set the environment variable PY_CGI_PORT"
    sys.exit(1)

try:
    os.environ['FTP_SUBMISSION_DEBUG_PORT']
except KeyError:
    print "Please set the environment variable FTP_SUBMISSION_DEBUG_PORT"
    sys.exit(1)

# Define a request handler class that runs a command when it receives a POST
class RequestHandler (BaseHTTPServer.BaseHTTPRequestHandler):

    def do_POST(s):

        # Execute the command and prepare the POST response code.
        # Prints an error message to the console on failure.
        # This is a blocking function.  Use subprocess.Popen for non-blocking.
        status = call(["java", "-agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=" + DEBUG_PORT, "-jar", "/usr/local/src/nihms-submission/nihms-cli/target/nihms-cli-1.0.0-SNAPSHOT-shaded.jar", "/usr/local/src/nihms-submission/nihms-cli/src/main/resources/FilesystemModelBuilderTest.properties", "local"])
        if status != 0:
            print "Command '{} {}' failed with code {}".format(COMMAND, ARGS, status)
            code = 500
        else:
            code = 200

        # Prepare and send the response header
        s.send_response(code)
        s.send_header("Content-type", "text/html")
        s.end_headers()

# Create and run the server
if __name__ == "__main__":
    httpd = BaseHTTPServer.HTTPServer(("", int(PORT)), RequestHandler)
    try:
        httpd.serve_forever()
    except KeyboardInterrupt:
        pass
    httpd.server_close()
