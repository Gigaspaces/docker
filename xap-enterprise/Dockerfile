ARG JAVA_IMAGE=openjdk
ARG JAVA_TAG=8-alpine
FROM ${JAVA_IMAGE}:${JAVA_TAG}
ARG GS_PRODUCT=xap
ARG GS_VERSION=15.0.0
ARG GS_MILESTONE=m12
ARG GS_BUILD=20700-87
ARG GS_BUILD_NAME=15.0.0-m12-sat-79
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
ENV XAP_NIC_ADDRESS "#eth0:ip#"
ENV XAP_LOOKUP_PORT 4174
ENV XAP_LRMI_PORT 8200-8300
ENV XAP_MANAGER_REST_PORT 8090
ENV WEBUI_PORT 8099
ENV XAP_WEBSTER_HTTP_PORT 8199
ENV XAP_RMI_REGISTRY_PORT 10098
ENV XAP_REST_PORT 8089
##can't overwrite zookeeper_client_port
ENV XAP_ZOOKEEPER_CLIENT_PORT 2181
ENV XAP_MANAGER_ZOOKEEPER_DISCOVERY_PORT=2888
ENV XAP_MANAGER_ZOOKEEPER_LEADER_ELECTION_PORT=3888
EXPOSE ${XAP_LOOKUP_PORT} ${XAP_LRMI_PORT} ${WEBUI_PORT} ${XAP_MANAGER_REST_PORT} ${WEBUI_PORT} ${XAP_WEBSTER_HTTP_PORT} ${XAP_RMI_REGISTRY_PORT} ${XAP_REST_PORT} ${XAP_ZOOKEEPER_CLIENT_PORT} ${XAP_MANAGER_ZOOKEEPER_DISCOVERY_PORT}  ${XAP_MANAGER_ZOOKEEPER_LEADER_ELECTION_PORT}
ENV EXT_JAVA_OPTIONS "-Dcom.gs.multicast.discoveryPort=${XAP_LOOKUP_PORT} -Dcom.gs.transport_protocol.lrmi.bind-port=${XAP_LRMI_PORT} -Dcom.gs.manager.rest.port=${XAP_MANAGER_REST_PORT} -Dorg.openspaces.launcher.port=${WEBUI_PORT} -Dcom.gigaspaces.start.httpPort=${XAP_WEBSTER_HTTP_PORT} -Dcom.gigaspaces.start.rmi.registryPort=${XAP_RMI_REGISTRY_PORT}  -Dcom.gs.manager.zookeeper.discovery.port=${XAP_MANAGER_ZOOKEEPER_DISCOVERY_PORT} -Dcom.gs.manager.zookeeper.leader-election.port=${XAP_MANAGER_ZOOKEEPER_LEADER_ELECTION_PORT}"
ENTRYPOINT ["/opt/entrypoint.sh"]
CMD ["host", "run-agent", "--auto"]
