ARG JAVA_IMAGE=openjdk
ARG JAVA_TAG=8
FROM ${JAVA_IMAGE}:${JAVA_TAG}
ENV GS_HOME /opt/gigaspaces
# Download
ARG GS_VERSION=12.3.0
ARG GS_MILESTONE=m18
ARG GS_BUILD=18918
ARG GS_NAME=gigaspaces-insightedge-${GS_VERSION}-${GS_MILESTONE}-b${GS_BUILD}
ADD https://gigaspaces-releases-eu.s3.amazonaws.com/com/gigaspaces/insightedge/${GS_VERSION}/${GS_VERSION}-${GS_MILESTONE}/${GS_NAME}.zip /tmp/gigaspaces.zip
# Unzip and delete zip
RUN unzip -q /tmp/gigaspaces.zip -d /tmp && \
    mv /tmp/${GS_NAME} ${GS_HOME} && \
    rm -f /tmp/gigaspaces.zip
WORKDIR ${GS_HOME}
ENV XAP_NIC_ADDRESS "#eth0:ip#"
ENV WEBUI_PORT 8099
ENV XAP_MANAGER_REST_PORT 8090
EXPOSE ${WEBUI_PORT} ${XAP_MANAGER_REST_PORT}
ENTRYPOINT ["bin/xap"]
CMD ["--help"]
