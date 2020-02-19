FROM openjdk:8-jre-alpine

ENV ACTIVEMQ_VERSION 5.15.11
ENV ACTIVEMQ_DIST=apache-activemq-$ACTIVEMQ_VERSION \
    ACTIVEMQ_JMS_PORT=61616 \ 
    ACTIVEMQ_STOMP_PORT=61613 \ 
    ACTIVEMQ_WEBCONSOLE_PORT=8161 \
    ACTIVEMQ_HOME=/usr/local/activemq

RUN apk add gettext && \ 
    wget -O activemq.tar.gz \
        https://archive.apache.org/dist/activemq/${ACTIVEMQ_VERSION}/${ACTIVEMQ_DIST}-bin.tar.gz && \
    tar xzvf activemq.tar.gz -C  /usr/local && \
    ln -s /usr/local/$ACTIVEMQ_DIST $ACTIVEMQ_HOME && \
    addgroup -S activemq && adduser -S -H -G activemq -h $ACTIVEMQ_HOME activemq && \
    chown -R activemq:activemq /usr/local/$ACTIVEMQ_DIST && \
    chown -h activemq:activemq ${ACTIVEMQ_HOME} && \
    rm activemq.tar.gz



COPY entrypoint.sh /usr/local/bin/entrypoint.sh
COPY activemq.xml /
RUN chmod 0755 /usr/local/bin/entrypoint.sh

WORKDIR $ACTIVEMQ_HOME
USER activemq

CMD ["/bin/sh", "-c", "/usr/local/bin/entrypoint.sh"]