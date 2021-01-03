#!/bin/bash

SPARK_JAVA_OPTIONS_FILE="${GS_HOME}/insightedge/spark/conf/java-opts"

if [ -z "$GS_MANAGER_SERVERS" ]; then
    if [ -z "$GS_PUBLIC_HOST"  ]; then
	    export GS_MANAGER_SERVERS=$HOSTNAME
    else
        export GS_MANAGER_SERVERS=$GS_PUBLIC_HOST
    fi
fi

if [ -f "${SPARK_JAVA_OPTIONS_FILE}" ]; then
	rm ${SPARK_JAVA_OPTIONS_FILE}
fi

echo "${GS_OPTIONS_EXT}" >> ${SPARK_JAVA_OPTIONS_FILE}

/opt/gigaspaces/bin/gs.sh $*
