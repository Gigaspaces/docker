ARG JAVA_IMAGE=openjdk
ARG JAVA_TAG=8-alpine
FROM ${JAVA_IMAGE}:${JAVA_TAG}
ARG GS_PRODUCT=insightedge
ARG GS_VERSION=15.2.0
ARG GS_MILESTONE=m6
ARG GS_BUILD=20700-87
ARG GS_BUILD_NAME=15.2.0-m6-fri-13
ARG GS_NAME=gigaspaces-${GS_PRODUCT}-enterprise-${GS_BUILD_NAME}
ARG GS_URL=https://gigaspaces-releases-eu.s3.amazonaws.com/${GS_PRODUCT}/${GS_VERSION}/${GS_NAME}.zip
ENV GS_HOME /opt/gigaspaces
WORKDIR ${GS_HOME}
# Download $GS_URL and unzip to $GS_HOME
RUN apk --no-cache add openssl wget unzip &&\
    wget --progress=bar:force -O /tmp/gigaspaces.zip ${GS_URL} &&\
    unzip -q /tmp/gigaspaces.zip -d /tmp &&\
    mkdir -p ${GS_HOME} &&\
    mv /tmp/${GS_NAME}/* ${GS_HOME}/ &&\
    rm -f /tmp/gigaspaces.zip

RUN apk add --no-cache nss
RUN apk update && apk add --no-cache libc6-compat
# Install kubernetes java client uber jar
RUN if test -f ${GS_HOME}/tools/kubernetes/client/pom.xml;then\
    apk --no-cache add maven &&\
    mvn package clean --file=${GS_HOME}/tools/kubernetes/client/pom.xml &&\
    apk --no-cache del maven;\
    fi
# Configure and expose ports
ENV LD_LIBRARY_PATH "/lib:/lib64"
ENV GS_NIC_ADDRESS "#eth0:ip#"
ENV GS_MULTICAST_LOOKUP_PORT 4174
ENV GS_LRMI_PORT 8200-8300
ENV GS_MANAGER_REST_PORT 8090
ENV GS_WEBUI_PORT 8099
ENV GS_WEBSTER_HTTP_PORT 8199
ENV GS_RMI_REGISTRY_PORT 10098
ENV GS_REST_PORT 8089
ENV GS_ZOOKEEPER_CLIENT_PORT 2181
ENV GS_MANAGER_ZOOKEEPER_DISCOVERY_PORT 2888
ENV GS_MANAGER_ZOOKEEPER_LEADER_ELECTION_PORT 3888
ENV SPARK_MASTER_PORT 7077
ENV SPARK_MASTER_WEBUI_PORT 8080
ENV SPARK_MASTER_REST_PORT 6066
ENV ZEPPELIN_PORT 9090
EXPOSE ${GS_MULTICAST_LOOKUP_PORT} ${GS_LRMI_PORT} ${GS_MANAGER_REST_PORT} ${GS_WEBUI_PORT} ${GS_WEBSTER_HTTP_PORT} ${GS_RMI_REGISTRY_PORT} ${GS_REST_PORT} ${GS_ZOOKEEPER_CLIENT_PORT} ${GS_MANAGER_ZOOKEEPER_DISCOVERY_PORT} ${GS_MANAGER_ZOOKEEPER_LEADER_ELECTION_PORT} ${SPARK_MASTER_PORT} ${SPARK_MASTER_WEBUI_PORT} ${SPARK_MASTER_REST_PORT} ${ZEPPELIN_PORT}


# Configure Spark directory structure
ENV SPARK_HOME ${GS_HOME}/insightedge/spark
ENV SPARK_CONF_DIR "${SPARK_HOME}/conf"
RUN set -ex && \
    apk upgrade --no-cache && \
    apk add --no-cache bash tini libc6-compat linux-pam && \
    mkdir -p ${SPARK_HOME} && \
    mkdir -p ${SPARK_HOME}/work-dir && \
    touch ${SPARK_HOME}/RELEASE && \
    rm /bin/sh && \
    ln -sv /bin/bash /bin/sh && \
    echo "auth required pam_wheel.so use_uid" >> /etc/pam.d/su && \
    chgrp root /etc/passwd && chmod ug+rw /etc/passwd

ARG SPARK_K8S_CLIENT_VERSION=4.4.2
RUN wget https://repo1.maven.org/maven2/io/fabric8/kubernetes-client/${SPARK_K8S_CLIENT_VERSION}/kubernetes-client-${SPARK_K8S_CLIENT_VERSION}.jar
RUN wget https://repo1.maven.org/maven2/io/fabric8/kubernetes-model/${SPARK_K8S_CLIENT_VERSION}/kubernetes-model-${SPARK_K8S_CLIENT_VERSION}.jar
RUN wget https://repo1.maven.org/maven2/io/fabric8/kubernetes-model-common/${SPARK_K8S_CLIENT_VERSION}/kubernetes-model-common-${SPARK_K8S_CLIENT_VERSION}.jar
RUN rm ${SPARK_HOME}/jars/kubernetes-*.jar
RUN mv kubernetes-client-${SPARK_K8S_CLIENT_VERSION}.jar ${SPARK_HOME}/jars/
RUN mv kubernetes-model-${SPARK_K8S_CLIENT_VERSION}.jar ${SPARK_HOME}/jars/
RUN mv kubernetes-model-common-${SPARK_K8S_CLIENT_VERSION}.jar ${SPARK_HOME}/jars/

# Configure Classpath environment variables
ENV INSIGHTEDGE_CLASSPATH "${GS_HOME}/insightedge/lib/*:${GS_HOME}/insightedge/lib/jdbc/*:${GS_HOME}/insightedge/lib/analytics-xtreme/*:${GS_HOME}/lib/required/*:${GS_HOME}/lib/optional/spatial/*"
ENV SPARK_DIST_CLASSPATH "${SPARK_DIST_CLASSPATH}:${INSIGHTEDGE_CLASSPATH}"

# Configure InsightEdge application's environment variables
ENV INSIGHTEDGE_SPACE_NAME insightedge-space

# Add entrypoints to directory structure
ADD docker-entrypoint.sh /opt/docker-entrypoint.sh
ADD entrypoint.sh /opt/entrypoint.sh
RUN cp /opt/gigaspaces/insightedge/spark/kubernetes/dockerfiles/spark/entrypoint.sh /opt/spark_entrypoint.sh

# Configure Docker entrypoint
ENTRYPOINT [ "/opt/docker-entrypoint.sh" ]
CMD ["host", "run-agent", "--auto"]
