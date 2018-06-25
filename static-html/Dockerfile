FROM alpine:3.7 as static-builder

ARG STATIC_HTML_GIT_REPO
ARG STATIC_HTML_GIT_BRANCH

ENV STATIC_HTML_DIR=/html

RUN apk add --no-cache git && \
    mkdir ${STATIC_HTML_DIR}

RUN cd ${STATIC_HTML_DIR} && \
    git clone ${STATIC_HTML_GIT_REPO} . && \
    git checkout ${STATIC_HTML_GIT_BRANCH}

FROM nginx:1.13.12-alpine

ENV STATIC_HTML_PORT=80 

COPY --from=static-builder /html/ /usr/share/nginx/html/
COPY bin/entrypoint.sh /bin/
COPY nginx-template.conf /

RUN apk --no-cache add gettext && \
    chmod a+x /bin/entrypoint.sh
    

ENTRYPOINT [ "/bin/entrypoint.sh" ]