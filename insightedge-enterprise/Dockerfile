ARG JAVA_IMAGE=openjdk
ARG JAVA_TAG=8
FROM ${JAVA_IMAGE}:${JAVA_TAG}
ARG GS_VERSION=12.3.0
ARG GS_MILESTONE=m20
ARG GS_BUILD=18920
ARG GS_NAME=gigaspaces-insightedge-${GS_VERSION}-${GS_MILESTONE}-b${GS_BUILD}
ARG GS_URL=https://gigaspaces-releases-eu.s3.amazonaws.com/com/gigaspaces/insightedge/${GS_VERSION}/${GS_VERSION}-${GS_MILESTONE}/${GS_NAME}.zip
ENV GS_HOME /opt/gigaspaces
# Download $GS_URL and unzip to $GS_HOME
RUN wget --progress=bar:force -O /tmp/gigaspaces.zip ${GS_URL} &&\
    unzip -q /tmp/gigaspaces.zip -d /tmp && \
    mv /tmp/${GS_NAME} ${GS_HOME} && \
    rm -f /tmp/gigaspaces.zip
WORKDIR ${GS_HOME}
# Configure and expose ports
ENV XAP_NIC_ADDRESS "#eth0:ip#"
ENV XAP_LOOKUP_PORT 4174
ENV XAP_LRMI_PORT 8200-8300
ENV XAP_MANAGER_REST_PORT 8090
# TODO: Consider renaming WEBUI_PORT => XAP_WEBUI_PORT (see webui launcher)
ENV WEBUI_PORT 8099
ENV SPARK_MASTER_PORT 7077
ENV SPARK_MASTER_WEBUI_PORT 8080
# TODO: Should we expose SPARK_WORKER_WEBUI_PORT as well (e.g. for ui/troubleshooting)?
ENV ZEPPELIN_PORT 9090
EXPOSE ${XAP_LOOKUP_PORT} ${XAP_LRMI_PORT} ${XAP_MANAGER_REST_PORT} ${WEBUI_PORT} ${SPARK_MASTER_PORT} ${SPARK_MASTER_WEBUI_PORT} ${ZEPPELIN_PORT}
# TODO: Enhance code to detect env vars in addition to system props to avoid this line
ENV EXT_JAVA_OPTIONS "-Dcom.gs.multicast.discoveryPort=${XAP_LOOKUP_PORT} -Dcom.gs.transport_protocol.lrmi.bind-port=${XAP_LRMI_PORT}"
# TODO: Chmod bin/xap to executable pending fix
RUN chmod 777 bin/xap
# TODO: replace bin/xap with bin/insightedge once implemented
ENTRYPOINT ["bin/xap"]
CMD ["host", "run-agent", "--auto"]
# TODO: Verify works with docker run --net=host (linux only)
# TODO: Verify outside client (e.g. gs-ui or benchmark) can connect with dockerized space
# TODO: Verify can submit job from host to spark/ie running in docker