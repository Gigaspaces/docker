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
ENV XAP_NIC_ADDRESS "#eth0:ip#"
ENV WEBUI_PORT 8099
ENV XAP_MANAGER_REST_PORT 8090
EXPOSE ${WEBUI_PORT} ${XAP_MANAGER_REST_PORT}
ENTRYPOINT ["bin/xap"]
CMD ["host", "run-agent", "--auto"]
