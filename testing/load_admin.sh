#! /bin/sh

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

curl -v -i -# -u  ${PASS_FEDORA_USER}:${PASS_FEDORA_PASSWORD} -X POST -H "Content-Type: application/ld+json" --data-binary "@admin.json" ${PASS_FEDORA_BASEURL}users


