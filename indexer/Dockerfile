FROM openjdk:8u212-jre-alpine3.9@sha256:5c5867cd2d4d198d1e53562c8202dfa388832b6f7d8276e69eae212b326c7777

ENV PI_VERSION=0.1.0 \
PI_MAX_ATTEMPTS=20 \
ESCONFIG_VERSION=3.5

ENV PI_ES_CONFIG=/app/esconfig-${ESCONFIG_VERSION}.json

WORKDIR /app

ADD wait_and_start.sh /app

RUN apk add --no-cache ca-certificates wget gettext curl && \
    wget https://repo1.maven.org/maven2/org/eclipse/pass/pass-indexer-cli/${PI_VERSION}/pass-indexer-cli-${PI_VERSION}-shaded.jar && \
    echo "3d47917f7039984902c3fe829c51d1d08cafd504 *pass-indexer-cli-${PI_VERSION}-shaded.jar" \
        | sha1sum -c -  && \
    wget https://eclipse-pass.github.io/pass-data-model/src/main/resources/esconfig-${ESCONFIG_VERSION}.json && \
    rm -rf /var/cache/apk/ && \
    chmod 700 wait_and_start.sh && \
    echo "networkaddress.cache.ttl=10" >> ${JAVA_HOME}/lib/security/java.security

CMD ./wait_and_start.sh pass-indexer-cli-${PI_VERSION}-shaded.jar
