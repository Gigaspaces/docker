ARG JAVA_IMAGE=openjdk
ARG JAVA_TAG=8
FROM ${JAVA_IMAGE}:${JAVA_TAG}
ARG GS_VERSION=12.3.0
ARG GS_MILESTONE=m18
ARG GS_BUILD=18918
ARG GS_NAME=gigaspaces-xap-${GS_VERSION}-${GS_MILESTONE}-b${GS_BUILD}
ARG GS_URL=https://gigaspaces-releases-eu.s3.amazonaws.com/com/gigaspaces/xap/${GS_VERSION}/${GS_VERSION}-${GS_MILESTONE}/${GS_NAME}.zip
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
EXPOSE ${XAP_LOOKUP_PORT} ${XAP_LRMI_PORT} ${WEBUI_PORT} ${XAP_MANAGER_REST_PORT}
# TODO: Enhance code to detect env vars in addition to system props to avoid this line
ENV EXT_JAVA_OPTIONS "-Dcom.gs.multicast.discoveryPort=${XAP_LOOKUP_PORT} -Dcom.gs.transport_protocol.lrmi.bind-port=${XAP_LRMI_PORT}"
ENTRYPOINT ["bin/xap"]
CMD ["host", "run-agent", "--auto"]
# TODO: Verify works with docker run --net=host (linux only)
# TODO: Verify outside client (e.g. gs-ui or benchmark) can connect with dockerized space