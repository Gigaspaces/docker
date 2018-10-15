#!/bin/bash

# echo commands to the terminal output
# set -ex

CMD_ARGS="$1"
case "$CMD_ARGS" in
  driver|executor|init)
    # Delegate arguments to Spark entrypoint
    CMD=(
      "/opt/spark_entrypoint.sh"
      "$@"
    )
    ;;

  *)
    # Delegate arguments to InsightEdge entrypoint
    CMD=("/opt/entrypoint.sh"
         "$@"
    )
esac

# WORKAROUND FOR WINDOWS BUG USING SPARK SUBMIT
# https://issues.apache.org/jira/browse/SPARK-24599
if [ -n "$SPARK_MOUNTED_CLASSPATH" ]; then
  SPARK_MOUNTED_CLASSPATH_FIX=$(echo "$SPARK_MOUNTED_CLASSPATH" | tr ';' ':')
  export SPARK_MOUNTED_CLASSPATH="${SPARK_MOUNTED_CLASSPATH_FIX}"
fi

# Execute the container CMD under tini for better hygiene
echo "Executing command: ${CMD[@]}" 1>&2
exec /sbin/tini -s -- "${CMD[@]}"
