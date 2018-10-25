FROM openjdk:8u151-jre-alpine3.7@sha256:795d1c079217bdcbff740874b78ddea80d5df858b3999951a33871ee61de15ce

ENV PI_VERSION=0.0.16
ENV PI_MAX_ATTEMPTS=20

WORKDIR /app

ADD wait_and_start.sh /app

RUN apk add --no-cache ca-certificates wget gettext curl && \
    wget https://github.com/OA-PASS/pass-indexer/releases/download/${PI_VERSION}/pass-indexer-cli-${PI_VERSION}-SNAPSHOT-shaded.jar && \
    echo "9128e09171fb7afd2101b0aa81cfbd70c0b83907 *pass-indexer-cli-${PI_VERSION}-SNAPSHOT-shaded.jar" \
        | sha1sum -c -  && \
    rm -rf /var/cache/apk/ && \
    chmod 700 wait_and_start.sh 

CMD ./wait_and_start.sh pass-indexer-cli-${PI_VERSION}-SNAPSHOT-shaded.jar
