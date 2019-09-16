#!/bin/bash

SPARK_JAVA_OPTIONS_FILE="${GS_HOME}/insightedge/spark/conf/java-opts"

if [ -f "${SPARK_JAVA_OPTIONS_FILE}" ]; then
	rm ${SPARK_JAVA_OPTIONS_FILE}
fi

echo "${GS_OPTIONS_EXT}" >> ${SPARK_JAVA_OPTIONS_FILE}

/opt/gigaspaces/bin/gs.sh $*
