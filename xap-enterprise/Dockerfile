ARG JAVA_IMAGE=openjdk
ARG JAVA_TAG=8
FROM ${JAVA_IMAGE}:${JAVA_TAG}
ARG GS_PRODUCT=xap
ARG GS_VERSION=14.0.1
ARG GS_MILESTONE=m1
ARG GS_BUILD=20200-94
ARG GS_NAME=gigaspaces-${GS_PRODUCT}-enterprise-${GS_VERSION}-${GS_MILESTONE}-b${GS_BUILD}
ARG GS_URL=https://gigaspaces-releases-eu.s3.amazonaws.com/${GS_PRODUCT}/${GS_VERSION}/${GS_NAME}.zip
ENV GS_HOME /opt/gigaspaces
# Download $GS_URL and unzip to $GS_HOME
RUN wget --progress=bar:force -O /tmp/gigaspaces.zip ${GS_URL} &&\
    unzip -q /tmp/gigaspaces.zip -d /tmp && \
    mv /tmp/${GS_NAME} ${GS_HOME} && \
    rm -f /tmp/gigaspaces.zip
WORKDIR ${GS_HOME}
ADD entrypoint.sh /opt/entrypoint.sh
# Configure and expose ports
ENV XAP_NIC_ADDRESS "#eth0:ip#"
ENV XAP_LOOKUP_PORT 4174
ENV XAP_LRMI_PORT 8200-8300
ENV XAP_MANAGER_REST_PORT 8090
ENV WEBUI_PORT 8099
ENV XAP_WEBSTER_HTTP_PORT 8199
ENV XAP_RMI_REGISTRY_PORT 10098
##can't overwrite zookeeper_client_port
ENV XAP_ZOOKEEPER_CLIENT_PORT 2181
ENV XAP_MANAGER_ZOOKEEPER_DISCOVERY_PORT=2888
ENV XAP_MANAGER_ZOOKEEPER_LEADER_ELECTION_PORT=3888
EXPOSE ${XAP_LOOKUP_PORT} ${XAP_LRMI_PORT} ${WEBUI_PORT} ${XAP_MANAGER_REST_PORT} ${WEBUI_PORT} ${XAP_WEBSTER_HTTP_PORT} ${XAP_RMI_REGISTRY_PORT} ${XAP_ZOOKEEPER_CLIENT_PORT} ${XAP_MANAGER_ZOOKEEPER_DISCOVERY_PORT}  ${XAP_MANAGER_ZOOKEEPER_LEADER_ELECTION_PORT}
ENV EXT_JAVA_OPTIONS "-Dcom.gs.multicast.discoveryPort=${XAP_LOOKUP_PORT} -Dcom.gs.transport_protocol.lrmi.bind-port=${XAP_LRMI_PORT} -Dcom.gs.manager.rest.port=${XAP_MANAGER_REST_PORT} -Dorg.openspaces.launcher.port=${WEBUI_PORT} -Dcom.gigaspaces.start.httpPort=${XAP_WEBSTER_HTTP_PORT} -Dcom.gigaspaces.start.rmi.registryPort=${XAP_RMI_REGISTRY_PORT}  -Dcom.gs.manager.zookeeper.discovery.port=${XAP_MANAGER_ZOOKEEPER_DISCOVERY_PORT} -Dcom.gs.manager.zookeeper.leader-election.port=${XAP_MANAGER_ZOOKEEPER_LEADER_ELECTION_PORT}"
ENTRYPOINT ["/opt/entrypoint.sh"]
CMD ["host", "run-agent", "--auto"]
