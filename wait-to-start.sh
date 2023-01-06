#! /bin/sh

PI_FEDORA_EXTERNAL_BASE="${PI_FEDORA_EXTERNAL_BASE:-http://pass.local:8080/data}"
PI_FEDORA_USER="fedoraAdmin"
PI_FEDORA_PASS="moo"
PI_MAX_ATTEMPTS=100

# curl \
#     -I \
#     -u ${PI_FEDORA_USER}:${PI_FEDORA_PASS} \
#     --write-out %{http_code} \
#     --silent \
#     -o /dev/stderr \
#     --retry 50 \
#     --retry-delay 5 \
#     --retry-max-time 300 \
#     --max-time 10 \
#     ${PI_FEDORA_EXTERNAL_BASE}

CMD="curl -I -u ${PI_FEDORA_USER}:${PI_FEDORA_PASS} --write-out %{http_code} --silent -o /dev/stderr ${PI_FEDORA_EXTERNAL_BASE}"
echo "Waiting for response from Fedora via 'curl -I -u <u>:<p> ${PI_FEDORA_EXTERNAL_BASE}'"

RESULT=0
max=${PI_MAX_ATTEMPTS}
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