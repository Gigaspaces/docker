ARG BASE_IMAGE=registry.access.redhat.com/ubi9-minimal
ARG BASE_TAG=latest
FROM ${BASE_IMAGE}:${BASE_TAG}
# The argument below is no longer used. We are moving to ubi8/openjdk-11 image
# instead of post-install of jdk due to tzdb corruption in upstream repo.
ARG JAVA_VERSION=java-17-openjdk-headless
ARG GS_PRODUCT=smart-cache
ARG GS_VERSION=16.5.0
ARG GS_BUILD_NAME=16.5.0-jdk17-ci-479
ARG GS_NAME=gigaspaces-${GS_PRODUCT}-enterprise-${GS_BUILD_NAME}
ARG GS_BUCKET=gs-releases-us-east-1
ENV GS_BUCKET $GS_BUCKET
ARG GS_URL=https://${GS_BUCKET}.s3.amazonaws.com/${GS_PRODUCT}/${GS_VERSION}/${GS_NAME}.zip
ENV GS_HOME /opt/gigaspaces
ENV GS_PRODUCT ${GS_PRODUCT}
ENV KUBERNETES_CLIENT_URL=https://repo1.maven.org/maven2/io/kubernetes/client-java/20.0.0/client-java-20.0.0.jar
ENV KUBERNETES_CLIENT_API_URL=https://repo1.maven.org/maven2/io/kubernetes/client-java-api/20.0.0/client-java-api-20.0.0.jar

WORKDIR ${GS_HOME}
# Download $GS_URL and unzip to $GS_HOME
USER root

RUN microdnf upgrade \
    --refresh \
    --best \
    --nodocs \
    --noplugins \
    --assumeyes \
    --setopt=install_weak_deps=0 &&\
    microdnf install $JAVA_VERSION jq shadow-utils hostname bind-utils nss wget unzip --assumeyes &&\
    microdnf clean all --assumeyes &&\
    wget --progress=bar:force -O /tmp/gigaspaces.zip ${GS_URL} &&\
    unzip -q /tmp/gigaspaces.zip -d /tmp &&\
    mkdir -p ${GS_HOME}/work &&\
    mv /tmp/${GS_NAME}/* ${GS_HOME}/ &&\
    rm -f /tmp/gigaspaces.zip &&\
    wget ${KUBERNETES_CLIENT_URL} -O ${GS_HOME}/tools/kubernetes/lib/k8s-java-client.jar &&\
    echo "#!/bin/bash" > /bin/kill && echo "kill \$@" >> /bin/kill && chmod +x /bin/kill
RUN groupadd --gid 2000 --system gs_group &&\
    adduser --shell /bin/nologin --uid 2001 --gid 2000 gs_user &&\
    chown -R gs_user:0 ${GS_HOME}
ADD entrypoint.sh /opt/entrypoint.sh

# Configure and expose ports
ENV LD_LIBRARY_PATH "/lib:/lib64"
ENV GS_NIC_ADDRESS "#eth0:ip#"
ENV GS_MULTICAST_LOOKUP_PORT 4174
ENV GS_LRMI_PORT 8200-8299
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

USER gs_user

ENTRYPOINT ["/opt/entrypoint.sh"]
CMD ["host", "run-agent", "--auto"]
