#! /bin/sh

# Argument should be authz jar to run.
# Wait until we get a 200 from Fedora or fail some number of times.
# Then start authz.

if [ -z "$JMS_BROKERURL" ]; then
    export JMS_BROKERURL=${SPRING_ACTIVEMQ_BROKER_URL}
fi

if [ -z "$JMS_USERNAME" ]; then
    export JMS_USERNAME=${SPRING_ACTIVEMQ_USER}
fi

if [ -z "$JMS_PASSWORD" ]; then
    export JMS_PASSWORD=${SPRING_ACTIVEMQ_PASSWORD}
fi

printf "\n**** Begin Environment Variable Dump ****\n\n"
printenv | sort
printf "\n**** End Environment Variable Dump ****\n\n"


function wait_until_fedora_up {
    CMD="curl -I -u ${PASS_FEDORA_USER}:${PASS_FEDORA_PASSWORD} --write-out %{http_code} --silent -o /dev/stderr ${PASS_FEDORA_BASEURL}"
    echo "Waiting for response from Fedora via ${CMD}"

    RESULT=0
    max=${AUTHZ_MAX_ATTEMPTS}
    i=1
    
    until [ ${RESULT} -eq 200 ]
    do
        sleep 5
        
        RESULT=$(${CMD})

        if [ $i -eq $max ]
        then
           echo "Reached max attempts"
           exit 1
        fi

        i=$((i+1))
        echo "Trying again, result was ${RESULT}"
    done
    
    echo "Fedora is up."
}

wait_until_fedora_up

echo "Executing java -jar ${1}"
exec java -jar "$1"
