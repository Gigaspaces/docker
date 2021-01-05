ARG JAVA_IMAGE=openjdk
ARG JAVA_TAG=8-alpine
FROM ${JAVA_IMAGE}:${JAVA_TAG}
ARG GS_PRODUCT=insightedge
ARG GS_VERSION=15.8.0
ARG GS_MILESTONE=rc1
ARG GS_BUILD=20700-87
ARG GS_BUILD_NAME=15.8.0-rc1-tue-19
ARG GS_NAME=gigaspaces-${GS_PRODUCT}-${GS_BUILD_NAME}
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
# Configure and expose ports
ENV GS_NIC_ADDRESS "#eth0:ip#"
ENV GS_MULTICAST_LOOKUP_PORT 4174
ENV GS_LRMI_PORT 8200-8300
ENV GS_WEBSTER_HTTP_PORT 8199
ENV GS_RMI_REGISTRY_PORT 10098
ENV GS_REST_PORT 8089
ENV SPARK_MASTER_PORT 7077
ENV SPARK_MASTER_WEBUI_PORT 8080
ENV SPARK_MASTER_REST_PORT 6066
ENV ZEPPELIN_PORT 9090

EXPOSE ${GS_MULTICAST_LOOKUP_PORT} ${GS_LRMI_PORT} ${GS_WEBSTER_HTTP_PORT} ${GS_RMI_REGISTRY_PORT} ${GS_REST_PORT} ${SPARK_MASTER_PORT} ${SPARK_MASTER_WEBUI_PORT} ${SPARK_MASTER_REST_PORT} ${ZEPPELIN_PORT} ${SPARK_MASTER_WEBUI_PORT} ${SPARK_MASTER_REST_PORT} ${ZEPPELIN_PORT}

ENTRYPOINT ["/opt/entrypoint.sh"]
CMD ["demo"]
