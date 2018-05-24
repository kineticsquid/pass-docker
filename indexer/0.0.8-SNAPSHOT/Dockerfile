FROM openjdk:8-jre-alpine

ENV PI_VERSION=0.0.8

WORKDIR /app

ADD wait_and_start.sh /app

RUN apk add --no-cache ca-certificates wget gettext curl && \
    wget https://github.com/OA-PASS/pass-indexer/releases/download/${PI_VERSION}/pass-indexer-cli-${PI_VERSION}-SNAPSHOT-shaded.jar && \
    rm -rf /var/cache/apk/ && \
    chmod 700 wait_and_start.sh 

CMD ./wait_and_start.sh pass-indexer-cli-${PI_VERSION}-SNAPSHOT-shaded.jar
