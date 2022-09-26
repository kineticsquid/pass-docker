FROM node:fermium-alpine3.15 as ember-builder

ARG EMBER_GIT_REPO
ARG EMBER_GIT_BRANCH
ARG EMBER_ROOT_URL
ARG USER_SERVICE_URL
ARG SCHEMA_SERVICE_URL
ARG DOI_SERVICE_URL
ARG POLICY_SERVICE_URL

ENV EMBER_GIT_BRANCH=${EMBER_GIT_BRANCH:-main} \
    EMBER_GIT_REPO=${EMBER_GIT_REPO:-https://github.com/eclipse-pass/pass-ui} \
    EMBER_BUILD_DIR=/ember \
    USER_SERVICE_URL=${USER_SERVICE_URL:-/pass-user-service/whoami} \
    SCHEMA_SERVICE_URL=${SCHEMA_SERVICE_URL:-/schemaservice} \
    DOI_SERVICE_URL=${DOI_SERVICE_URL:-/doiservice/journal} \
    POLICY_SERVICE_URL=${POLICY_SERVICE_URL:-/policies} \
    EMBER_ROOT_URL=${EMBER_ROOT_URL:-/app/} \
    METADATA_SCHEMA_URI=${METADATA_SCHEMA_URI:-https://oa-pass.github.com/metadata-schemas/jhu/global.json} \
    MANUSCRIPT_SERVICE_LOOKUP_URL=${MANUSCRIPT_SERVICE_LOOKUP_URL:-/downloadservice/lookup} \
    MANUSCRIPT_SERVICE_DOWNLOAD_URL=${MANUSCRIPT_SERVICE_DOWNLOAD_URL:-/downloadservice/download} \
    PASS_API_URL=${PASS_API_URL:-https://localhost} \
    PASS_API_NAMESPACE=${PASS_API_NAMESPACE:-/api/v1} \
    STATIC_CONFIG_URL=${STATIC_CONFIG_URL:-/app/config.json}


RUN apk add --no-cache git python2 g++ make && \
    node -v && npm -v && yarn -v && \
    mkdir -p ${EMBER_BUILD_DIR} && \
    cd ${EMBER_BUILD_DIR} && \
    git clone ${EMBER_GIT_REPO} . && \
    git checkout ${EMBER_GIT_BRANCH} && \
    yarn install && \
    echo "Build environment: " && \
    env | sort && \
    yarn run -B ember build --environment=production && \
    yarn cache clean

FROM nginx:1.13.12-alpine

ARG EMBER_ROOT_URL

ENV EMBER_PORT=80 \
    EMBER_ROOT_URL=${EMBER_ROOT_URL:-/app/}
COPY bin/entrypoint.sh /bin/
COPY nginx-template.conf /

RUN apk --no-cache add gettext && \
    chmod a+x /bin/entrypoint.sh && \
    mkdir /usr/share/nginx/html/app

COPY --from=ember-builder /ember/dist/ /usr/share/nginx/html/app/

ENTRYPOINT [ "/bin/entrypoint.sh" ]