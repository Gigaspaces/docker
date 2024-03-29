ARG BASE_IMAGE=registry.access.redhat.com/ubi8/openjdk-11
ARG BASE_TAG=1.16-3
FROM ${BASE_IMAGE}:${BASE_TAG}
# The argument below is no longer used. We are moving to ubi8/openjdk-11 image
# instead of post-install of jdk due to tzdb corruption in upstream repo.
#ARG JAVA_VERSION=java-11-openjdkARG GS_PRODUCT=smart-cache
ARG GS_VERSION=16.2.0
ARG GS_BUILD_NAME=16.2.0-m19-fri-70
ARG GS_NAME=gigaspaces-${GS_PRODUCT}-enterprise-${GS_BUILD_NAME}
ARG GS_BUCKET=gs-releases-us-east-1
ENV GS_BUCKET $GS_BUCKET
ARG GS_URL=https://${GS_BUCKET}.s3.amazonaws.com/${GS_PRODUCT}/${GS_VERSION}/${GS_NAME}.zip
ENV GS_HOME /opt/gigaspaces
ENV GS_PRODUCT ${GS_PRODUCT}
ENV KUBERNETES_CLINET_URL=https://resources.gigaspaces.com/k8s-java-client/k8s-java-client-15.0.1.jar

WORKDIR ${GS_HOME}
# Download $GS_URL and unzip to $GS_HOME
USER root

RUN microdnf install jq shadow-utils hostname bind-utils nss wget unzip &&\
    wget --progress=bar:force -O /tmp/gigaspaces.zip ${GS_URL} &&\
    unzip -q /tmp/gigaspaces.zip -d /tmp &&\
    mkdir -p ${GS_HOME}/work &&\
    mv /tmp/${GS_NAME}/* ${GS_HOME}/ &&\
    rm -f /tmp/gigaspaces.zip &&\
    wget ${KUBERNETES_CLINET_URL} -O ${GS_HOME}/tools/kubernetes/lib/k8s-java-client.jar
ADD entrypoint.sh /opt/entrypoint.sh

RUN echo "#!/bin/bash" > /bin/kill && echo "kill \$@" >> /bin/kill && chmod +x /bin/kill

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


RUN groupadd --gid 2000 --system gs_group &&\
    adduser -g gs_group -s /bin/nologin -u 1000 gs_user &&\
    chown -R gs_user:0 ${GS_HOME}

USER gs_user

ENTRYPOINT ["/opt/entrypoint.sh"]
CMD ["host", "run-agent", "--auto"]
