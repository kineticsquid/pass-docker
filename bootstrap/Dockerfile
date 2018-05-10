FROM alpine:3.7

COPY bin/* /bin/

RUN mkdir /data && \
    apk add --no-cache curl && \
    chmod 700 /bin/setup_fedora.sh

WORKDIR /data

COPY data/* /data/

ENTRYPOINT [ "/bin/setup_fedora.sh" ]