FROM openjdk:8u151-jre-alpine3.7@sha256:795d1c079217bdcbff740874b78ddea80d5df858b3999951a33871ee61de15ce

ENV VERSION=0.1.0-SNAPSHOT \
    AUTHZ_MAX_ATTEMPTS=20 \
    PASS_BACKEND_ROLE=http://oapass.org/ns/roles/johnshopkins.edu#pass-backend \
    PASS_GRANTADMIN_ROLE=http://oapass.org/ns/roles/johnshopkins.edu#admin \
    PASS_SUBMITTER_ROLE=http://oapass.org/ns/roles/johnshopkins.edu#submitter


WORKDIR /app

ADD wait_and_start.sh /app

RUN apk add --no-cache ca-certificates wget gettext curl && \
    wget https://github.com/OA-PASS/pass-authz/releases/download/${VERSION}/pass-authz-tools-${VERSION}-listener-exe.jar && \
    echo "6c1c26783a35dcba3dab480418d8bca51f47acf1 *pass-authz-tools-${VERSION}-listener-exe.jar" \
        | sha1sum -c -  && \
    rm -rf /var/cache/apk/ && \
    chmod 700 wait_and_start.sh 

CMD ./wait_and_start.sh pass-authz-tools-${VERSION}-listener-exe.jar
