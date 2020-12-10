ARG JAVA_IMAGE=openjdk
ARG JAVA_TAG=8-alpine
FROM ${JAVA_IMAGE}:${JAVA_TAG}
ARG GS_PRODUCT=xap
ARG GS_VERSION=15.8.0
ARG GS_MILESTONE=m16
ARG GS_BUILD=20700-87
ARG GS_BUILD_NAME=15.8.0-m16-ci-6
ARG GS_NAME=gigaspaces-${GS_PRODUCT}-enterprise-${GS_BUILD_NAME}
ARG GS_URL=https://gigaspaces-releases-eu.s3.amazonaws.com/${GS_PRODUCT}/${GS_VERSION}/${GS_NAME}.zip
ENV GS_HOME /opt/gigaspaces
WORKDIR ${GS_HOME}
# Download $GS_URL and unzip to $GS_HOME

COPY gigaspaces-xap-enterprise-15.8.0-m16-ci-6.zip /tmp/gigaspaces.zip
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

ENTRYPOINT ["/opt/entrypoint.sh"]
CMD []
