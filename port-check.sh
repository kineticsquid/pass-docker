/bin/bash

sudo lsof -i -P -n | grep LISTEN

rc = nc -w 0 127.0.0.1 80

echo rc
echo 'fred'