FROM tomcat:8.5.40-jre8-alpine@sha256:3bfda84777039e5150a74bfdff71979d1cb7106d74382a735a80f18b5d6d2ebb

ENV FCREPO_VERSION=4.7.5 \
JSONLD_ADDON_VERSION=0.1.1 \
PASS_AUTHZ_VERSION=0.1.0 \
JMS_ADDON_VERSION=0.1.0 \
POSTGRESQL_VERSION=42.3.2 \
FCREPO_HOME=${CATALINA_HOME}/fcrepo4-data \
FCREPO_HOST=fcrepo \
FCREPO_PORT=8080 \
FCREPO_JMS_PORT=61616 \
FCREPO_STOMP_PORT=61613 \
FCREPO_CONTEXT_PATH=/fcrepo \
FCREPO_LOG_LEVEL=INFO \
SPRING_ACTIVEMQ_URL=tcp://localhost:61616 \
FCREPO_CONNECTIONFACTORY=org.apache.activemq.ActiveMQConnectionFactory \
FCREPO_JMS_PUBLISHER=org.fcrepo.jms.JMSTopicPublisher \
FCREPO_JMS_DESTINATION=fedora \
FCREPO_ACTIVEMQ_CONFIGURATION=classpath:/config/activemq.xml \
FCREPO_SPRING_CONFIGURATION=classpath:/spring/master.xml \
FCREPO_MODESHAPE_CONFIGURATION=classpath:/pass-repository.json \
FCREPO_JMS_CONFIGURATION=classpath:/pass-jms.xml \
FCREPO_LOGBACK_LOCATION=webapps/fcrepo/WEB-INF/classes/logback.xml \
FCREPO_PROPERTIES_MANAGEMENT=relaxed \
SLF4J_VERSION=1.7.25 \
DEBUG_ARG="-agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=5006" \
COMPACTION_PRELOAD_URI_PASS_STATIC_2_0=https://oa-pass.github.io/pass-data-model/src/main/resources/context-2.0.jsonld \
COMPACTION_PRELOAD_FILE_PASS_STATIC_2_0=/usr/local/tomcat/lib/context-2.0.jsonld \
COMPACTION_PRELOAD_URI_PASS_STATIC_2_1=https://oa-pass.github.io/pass-data-model/src/main/resources/context-2.1.jsonld \
COMPACTION_PRELOAD_FILE_PASS_STATIC_2_1=/usr/local/tomcat/lib/context-2.1.jsonld \
COMPACTION_PRELOAD_URI_PASS_STATIC_2_2=https://oa-pass.github.io/pass-data-model/src/main/resources/context-2.2.jsonld \
COMPACTION_PRELOAD_FILE_PASS_STATIC_2_2=/usr/local/tomcat/lib/context-2.2.jsonld \
COMPACTION_PRELOAD_URI_PASS_STATIC_2_3=https://oa-pass.github.io/pass-data-model/src/main/resources/context-2.3.jsonld \
COMPACTION_PRELOAD_FILE_PASS_STATIC_2_3=/usr/local/tomcat/lib/context-2.3.jsonld \
COMPACTION_PRELOAD_URI_PASS_STATIC_3_0=https://oa-pass.github.io/pass-data-model/src/main/resources/context-3.0.jsonld \
COMPACTION_PRELOAD_FILE_PASS_STATIC_3_0=/usr/local/tomcat/lib/context-3.0.jsonld \
COMPACTION_PRELOAD_URI_PASS_STATIC_3_1=https://oa-pass.github.io/pass-data-model/src/main/resources/context-3.1.jsonld \
COMPACTION_PRELOAD_FILE_PASS_STATIC_3_1=/usr/local/tomcat/lib/context-3.1.jsonld \
COMPACTION_PRELOAD_URI_PASS_STATIC_3_2=https://oa-pass.github.io/pass-data-model/src/main/resources/context-3.2.jsonld \
COMPACTION_PRELOAD_FILE_PASS_STATIC_3_2=/usr/local/tomcat/lib/context-3.2.jsonld \
COMPACTION_PRELOAD_URI_PASS_STATIC_3_3=https://oa-pass.github.io/pass-data-model/src/main/resources/context-3.3.jsonld \
COMPACTION_PRELOAD_FILE_PASS_STATIC_3_3=/usr/local/tomcat/lib/context-3.3.jsonld \
COMPACTION_PRELOAD_URI_PASS_STATIC_3_4=https://oa-pass.github.io/pass-data-model/src/main/resources/context-3.4.jsonld \
COMPACTION_PRELOAD_FILE_PASS_STATIC_3_4=/usr/local/tomcat/lib/context-3.4.jsonld \
COMPACTION_PRELOAD_URI_PASS_STATIC_3_5=https://eclipse-pass.github.io/pass-data-model/src/main/resources/context-3.5.jsonld \
COMPACTION_PRELOAD_FILE_PASS_STATIC_3_5=/usr/local/tomcat/lib/context-3.5.jsonld \
COMPACTION_URI=https://eclipse-pass.github.io/pass-data-model/src/main/resources/context-3.5.jsonld \
JSONLD_STRICT=true \
JSONLD_CONTEXT_PERSIST=true \
JSONLD_CONTEXT_MINIMAL=true \
AUTHZ_USE_SHIB_HEADERS=true

EXPOSE ${FCREPO_PORT}

VOLUME /data

COPY bin/* /bin/
COPY conf/ ${CATALINA_HOME}/conf
COPY lib/* ${CATALINA_HOME}/lib/
COPY tomcat-bin/* ${CATALINA_HOME}/bin/

RUN apk update && \
    apk add --no-cache ca-certificates wget gettext curl python py-pip && \
    pip install awscli && \
    export FCREPO_WAR=fcrepo-webapp-${FCREPO_VERSION}.war && \
    wget -O ${CATALINA_HOME}/webapps/fcrepo.war \
    https://repo1.maven.org/maven2/org/fcrepo/fcrepo-webapp-plus/${FCREPO_VERSION}/fcrepo-webapp-plus-${FCREPO_VERSION}.war && \
    echo "95cd04e17eebfc9af5dd7a0968293f92bfd75bf0 *${CATALINA_HOME}/webapps/fcrepo.war" \
        | sha1sum -c -  && \
    echo "org.apache.catalina.webresources.Cache.level = SEVERE" \
      >> ${CATALINA_HOME}/conf/logging.properties && \
    wget -O ${CATALINA_HOME}/lib/jsonld-addon-filters-${JSONLD_ADDON_VERSION}-shaded.jar \
        https://repo1.maven.org/maven2/org/eclipse/pass/jsonld-addon-filters/${JSONLD_ADDON_VERSION}/jsonld-addon-filters-${JSONLD_ADDON_VERSION}-shaded.jar && \
    echo "56a7eef9deba0fa8b7d6b185e5d0fa00c098bc8d *${CATALINA_HOME}/lib/jsonld-addon-filters-${JSONLD_ADDON_VERSION}-shaded.jar" \
        | sha1sum -c -  && \
    wget -O ${CATALINA_HOME}/lib/pass-authz-core-${PASS_AUTHZ_VERSION}-shaded.jar \
        https://repo1.maven.org/maven2/org/eclipse/pass/pass-authz-core/${PASS_AUTHZ_VERSION}/pass-authz-core-${PASS_AUTHZ_VERSION}-shaded.jar && \
    echo "bd4393c4337f7e439584a9eb86073d4d5daa142f *${CATALINA_HOME}/lib/pass-authz-core-${PASS_AUTHZ_VERSION}-shaded.jar" \
       | sha1sum -c -  && \
    wget -O ${CATALINA_HOME}/lib/pass-authz-roles-${PASS_AUTHZ_VERSION}.jar \
            https://repo1.maven.org/maven2/org/eclipse/pass/pass-authz-roles/${PASS_AUTHZ_VERSION}/pass-authz-roles-${PASS_AUTHZ_VERSION}.jar && \
    echo "6c00bfa24c3f9ba29277da45961c044928e0c957 *${CATALINA_HOME}/lib/pass-authz-roles-${PASS_AUTHZ_VERSION}.jar" \
        | sha1sum -c -  && \
    wget -O ${CATALINA_HOME}/webapps/pass-user-service.war \
        https://repo1.maven.org/maven2/org/eclipse/pass/pass-user-service/${PASS_AUTHZ_VERSION}/pass-user-service-${PASS_AUTHZ_VERSION}.war && \
    echo "0f7138d13aeb5f53a9bda264dd68b9448314f01d *${CATALINA_HOME}/webapps/pass-user-service.war" \
        | sha1sum -c -  && \
    mkdir ${CATALINA_HOME}/webapps/pass-user-service && \
    unzip ${CATALINA_HOME}/webapps/pass-user-service.war -d ${CATALINA_HOME}/webapps/pass-user-service  && \
    rm ${CATALINA_HOME}/webapps/pass-user-service.war && \
    mkdir ${CATALINA_HOME}/webapps/fcrepo && \
    unzip ${CATALINA_HOME}/webapps/fcrepo.war -d ${CATALINA_HOME}/webapps/fcrepo  && \
    rm ${CATALINA_HOME}/webapps/fcrepo.war && \
    wget -O ${CATALINA_HOME}/webapps/fcrepo/WEB-INF/lib/jms-addon-${JMS_ADDON_VERSION}.jar \
            https://repo1.maven.org/maven2/org/eclipse/pass/jms-addon/${JMS_ADDON_VERSION}/jms-addon-${JMS_ADDON_VERSION}.jar && \
    echo "0f26835c7167a9339cb71b2ec45d926ea05b6955 *${CATALINA_HOME}/webapps/fcrepo/WEB-INF/lib/jms-addon-${JMS_ADDON_VERSION}.jar" \
        | sha1sum -c -  && \
    chmod 700 /bin/entrypoint.sh && \
    chmod 700 /bin/setup_fedora.sh && \
    chmod 700 /bin/awsentrypoint.sh

RUN export FCREPO_ACTIVEMQ_CONFIGURATION=classpath:/activemq-queue.xml && \
    export FCREPO_JMS_BASEURL=http://${FCREPO_HOST}:${FCREPO_PORT}/fcrepo/rest && \
    /bin/entrypoint.sh startup.sh && \
    /bin/setup_fedora.sh http://127.0.0.1:${FCREPO_PORT}/${FCREPO_CONTEXT_PATH}/rest && \
    ${CATALINA_HOME}/bin/shutdown.sh && \
    sed -i '/bootstrap/d' conf/tomcat-users.xml

RUN wget -O ${COMPACTION_PRELOAD_FILE_PASS_STATIC_2_0} \
        ${COMPACTION_PRELOAD_URI_PASS_STATIC_2_0} && \
    wget -O ${COMPACTION_PRELOAD_FILE_PASS_STATIC_2_1} \
        ${COMPACTION_PRELOAD_URI_PASS_STATIC_2_1} && \
    wget -O ${COMPACTION_PRELOAD_FILE_PASS_STATIC_2_2} \
        ${COMPACTION_PRELOAD_URI_PASS_STATIC_2_2} && \
    wget -O ${COMPACTION_PRELOAD_FILE_PASS_STATIC_2_3} \
        ${COMPACTION_PRELOAD_URI_PASS_STATIC_2_3} && \
    wget -O ${COMPACTION_PRELOAD_FILE_PASS_STATIC_3_0} \
        ${COMPACTION_PRELOAD_URI_PASS_STATIC_3_0} && \
    wget -O ${COMPACTION_PRELOAD_FILE_PASS_STATIC_3_1} \
        ${COMPACTION_PRELOAD_URI_PASS_STATIC_3_1} && \
    wget -O ${COMPACTION_PRELOAD_FILE_PASS_STATIC_3_2} \
        ${COMPACTION_PRELOAD_URI_PASS_STATIC_3_2} && \
    wget -O ${COMPACTION_PRELOAD_FILE_PASS_STATIC_3_3} \
        ${COMPACTION_PRELOAD_URI_PASS_STATIC_3_3} && \
    wget -O ${COMPACTION_PRELOAD_FILE_PASS_STATIC_3_4} \
        ${COMPACTION_PRELOAD_URI_PASS_STATIC_3_4} && \
    wget -O ${COMPACTION_PRELOAD_FILE_PASS_STATIC_3_5} \
        ${COMPACTION_PRELOAD_URI_PASS_STATIC_3_5} && \
    rm ${CATALINA_HOME}/webapps/fcrepo/WEB-INF/lib/modeshape-jcr-5.4.0.Final.jar && \
    wget -O ${CATALINA_HOME}/webapps/fcrepo/WEB-INF/lib/modeshape-jcr-5.4.0-maint-01.jar \
        https://github.com/OA-PASS/modeshape/releases/download/modeshape-5.4.0-maint-01/modeshape-jcr-5.4.0.Final.jar && \
    echo "159697fd2c15db3c9caf47f52f64c453e1ed67a2 *${CATALINA_HOME}/webapps/fcrepo/WEB-INF/lib/modeshape-jcr-5.4.0-maint-01.jar" \
        | sha1sum -c - && \
    rm ${CATALINA_HOME}/webapps/fcrepo/WEB-INF/lib/fcrepo-auth-roles-common-4.7.5.jar && \
    wget -O ${CATALINA_HOME}/webapps/fcrepo/WEB-INF/lib/fcrepo-auth-roles-common-4.7.5-fixes-01.jar \
      https://github.com/OA-PASS/fcrepo-module-auth-rbacl/releases/download/fixes-4.7.5-0/fcrepo-auth-roles-common-4.7.5.jar && \
    echo "21d21474ca15fa69741dd9bf66a0f39962eff8bd *${CATALINA_HOME}/webapps/fcrepo/WEB-INF/lib/fcrepo-auth-roles-common-4.7.5-fixes-01.jar" && \
    echo "networkaddress.cache.ttl=10" >> ${JAVA_HOME}/lib/security/java.security &&\
    wget -O ${CATALINA_HOME}/webapps/fcrepo/WEB-INF/lib/postgresql-${POSTGRESQL_VERSION}.jar \
        https://repo1.maven.org/maven2/org/postgresql/postgresql/${POSTGRESQL_VERSION}/postgresql-${POSTGRESQL_VERSION}.jar && \
    echo "8fd7a20f008a58b97b26ba5c5084ee61602203aa *${CATALINA_HOME}/webapps/fcrepo/WEB-INF/lib/postgresql-${POSTGRESQL_VERSION}.jar" \
        | sha1sum -c - && \
    rm ${CATALINA_HOME}/webapps/fcrepo/WEB-INF/lib/postgresql-9.4.1211.jar

COPY WEB-INF/ ${CATALINA_HOME}/webapps/fcrepo/WEB-INF/

ENTRYPOINT [ "/bin/entrypoint.sh" ]
