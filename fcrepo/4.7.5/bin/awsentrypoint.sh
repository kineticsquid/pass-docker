#!/bin/sh

echo "Fetching fcrepo_entrypoint.sh"
aws s3 cp s3://pass-configuration-files/entrypoints/fcrepo.sh /bin/fcrepo_entrypoint.sh

if [ -f /bin/fcrepo_entrypoint.sh ]; then
      echo "fcrepo_entrypoint.sh found...running"
      chmod 700 /bin/fcrepo_entrypoint.sh
      /bin/fcrepo_entrypoint.sh
fi

export OPTS="-Daws.bucket=${FCREPO_AWS_BUCKET}                          \
	     -Daws.accessKeyId=${FCREPO_AWS_USER}			\
      	     -Daws.secretKey=${FCREPO_AWS_PASSWORD}                    "

/bin/entrypoint.sh
