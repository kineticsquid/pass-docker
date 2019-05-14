FROM openjdk:8u212-jre-alpine3.9@sha256:5c5867cd2d4d198d1e53562c8202dfa388832b6f7d8276e69eae212b326c7777

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
    chmod 700 wait_and_start.sh && \
    echo "networkaddress.cache.ttl=10" >> ${JAVA_HOME}/lib/security/java.security

CMD ./wait_and_start.sh pass-indexer-cli-${PI_VERSION}-SNAPSHOT-shaded.jar
