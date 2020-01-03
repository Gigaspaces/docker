ARG JAVA_IMAGE=openjdk
ARG JAVA_TAG=8-alpine
FROM ${JAVA_IMAGE}:${JAVA_TAG}
ARG GS_PRODUCT=xap
ARG GS_VERSION=15.2.0
ARG GS_MILESTONE=m6
ARG GS_BUILD=20700-87
ARG GS_BUILD_NAME=15.2.0-m6-fri-13
ARG GS_NAME=gigaspaces-${GS_PRODUCT}-enterprise-${GS_BUILD_NAME}
ARG GS_URL=https://gigaspaces-releases-eu.s3.amazonaws.com/${GS_PRODUCT}/${GS_VERSION}/${GS_NAME}.zip
ENV GS_HOME /opt/gigaspaces
WORKDIR ${GS_HOME}
# Download $GS_URL and unzip to $GS_HOME
RUN apk --no-cache add openssl wget unzip bash libc6-compat &&\
    wget --progress=bar:force -O /tmp/gigaspaces.zip ${GS_URL} &&\
    unzip -q /tmp/gigaspaces.zip -d /tmp &&\
    mkdir -p ${GS_HOME} &&\
    mv /tmp/${GS_NAME}/* ${GS_HOME}/ &&\
    rm -f /tmp/gigaspaces.zip
ADD entrypoint.sh /opt/entrypoint.sh
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
##can't overwrite zookeeper_client_port
ENV GS_ZOOKEEPER_CLIENT_PORT 2181
ENV GS_MANAGER_ZOOKEEPER_DISCOVERY_PORT=2888
ENV GS_MANAGER_ZOOKEEPER_LEADER_ELECTION_PORT=3888
EXPOSE ${GS_MULTICAST_LOOKUP_PORT} ${GS_LRMI_PORT} ${GS_WEBUI_PORT} ${GS_MANAGER_REST_PORT} ${GS_WEBUI_PORT} ${GS_WEBSTER_HTTP_PORT} ${GS_RMI_REGISTRY_PORT} ${GS_REST_PORT} ${GS_ZOOKEEPER_CLIENT_PORT} ${GS_MANAGER_ZOOKEEPER_DISCOVERY_PORT}  ${GS_MANAGER_ZOOKEEPER_LEADER_ELECTION_PORT}

ENTRYPOINT ["/opt/entrypoint.sh"]
CMD ["host", "run-agent", "--auto"]
