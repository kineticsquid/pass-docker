FROM openjdk:8u171-jre-alpine3.8@sha256:e3168174d367db9928bb70e33b4750457092e61815d577e368f53efb29fea48b
ENV VERSION=0.4.0 \
    AUTHZ_MAX_ATTEMPTS=20 \
    PASS_BACKEND_ROLE=http://oapass.org/ns/roles/johnshopkins.edu#pass-backend \
    PASS_GRANTADMIN_ROLE=http://oapass.org/ns/roles/johnshopkins.edu#admin \
    PASS_SUBMITTER_ROLE=http://oapass.org/ns/roles/johnshopkins.edu#submitter


WORKDIR /app

ADD wait_and_start.sh /app

RUN apk add --no-cache ca-certificates wget gettext curl && \
    wget http://central.maven.org/maven2/org/dataconservancy/pass/pass-authz-listener/${VERSION}/pass-authz-listener-${VERSION}-exe.jar && \
    echo "00bc26f673a6033ac0ad4ba5aaac793b75e2208b *pass-authz-listener-${VERSION}-exe.jar" \
        | sha1sum -c -  && \
    rm -rf /var/cache/apk/ && \
    chmod 700 wait_and_start.sh 

CMD ./wait_and_start.sh pass-authz-listener-${VERSION}-exe.jar
