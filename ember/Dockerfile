FROM alpine:3.7 as ember-builder

ARG EMBER_GIT_REPO
ARG EMBER_GIT_BRANCH

ENV EMBER_GIT_BRANCH=${EMBER_GIT_BRANCH:-master} \
    EMBER_GIT_REPO=${EMBER_GIT_REPO:-https://github.com/OA-PASS/pass-ember} \
    EMBER_BUILD_DIR=/ember \
    FEDORA_ADAPTER_BASE=/fcrepo/rest/ \
    FEDORA_ADAPTER_CONTEXT=https://oa-pass.github.io/pass-data-model/src/main/resources/context-2.2.jsonld \
    FEDORA_ADAPTER_DATA=http://oapass.org/ns/pass# \
    FEDORA_ADAPTER_ES=/es/ \
    USER_SERVICE_URL=/pass-user-service/whoami

RUN apk add --no-cache nodejs-npm git && \
    mkdir -p ${EMBER_BUILD_DIR} && \
    cd ${EMBER_BUILD_DIR} && \
    git clone ${EMBER_GIT_REPO} . && \
    git checkout ${EMBER_GIT_BRANCH} && \
    npm install && \
    npm install -g ember-cli && \
    ember build --environment=production

FROM nginx:1.13.12-alpine

ENV EMBER_PORT=80
COPY bin/entrypoint.sh /bin/
COPY nginx-template.conf /

RUN apk --no-cache add gettext && \
    chmod a+x /bin/entrypoint.sh

COPY --from=ember-builder /ember/dist/ /usr/share/nginx/html/

ENTRYPOINT [ "/bin/entrypoint.sh" ]