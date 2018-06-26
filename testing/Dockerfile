FROM alpine:3.7

WORKDIR /app

ADD load_admin.sh /app
ADD admin.json /app

RUN apk add --no-cache ca-certificates wget gettext curl && \
    rm -rf /var/cache/apk/ && \
    chmod 700 load_admin.sh 

CMD ./load_admin.sh 
