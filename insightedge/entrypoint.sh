#!/bin/bash

SPARK_JAVA_OPTIONS_FILE="${GS_HOME}/insightedge/spark/conf/java-opts"

if [ -f "${SPARK_JAVA_OPTIONS_FILE}" ]; then
	rm ${SPARK_JAVA_OPTIONS_FILE}
fi

echo "${EXT_JAVA_OPTIONS}" >> ${SPARK_JAVA_OPTIONS_FILE}

/opt/gigaspaces/bin/insightedge $*
