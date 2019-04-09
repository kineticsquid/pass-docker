FROM openjdk:8u151-jre-alpine3.7@sha256:795d1c079217bdcbff740874b78ddea80d5df858b3999951a33871ee61de15ce

ENV PI_VERSION=0.0.18 \
PI_MAX_ATTEMPTS=20 \
ESCONFIG_VERSION=3.4

ENV PI_ES_CONFIG=/app/esconfig-${ESCONFIG_VERSION}.json

WORKDIR /app

ADD wait_and_start.sh /app

RUN apk add --no-cache ca-certificates wget gettext curl && \
    wget https://github.com/OA-PASS/pass-indexer/releases/download/${PI_VERSION}/pass-indexer-cli-${PI_VERSION}-SNAPSHOT-shaded.jar && \
    echo "97d1028118f56848a71a8196690633a30d4c4157 *pass-indexer-cli-${PI_VERSION}-SNAPSHOT-shaded.jar" \
        | sha1sum -c -  && \
    wget https://oa-pass.github.io/pass-data-model/src/main/resources/esconfig-${ESCONFIG_VERSION}.json && \
    rm -rf /var/cache/apk/ && \
    chmod 700 wait_and_start.sh 

CMD ./wait_and_start.sh pass-indexer-cli-${PI_VERSION}-SNAPSHOT-shaded.jar
