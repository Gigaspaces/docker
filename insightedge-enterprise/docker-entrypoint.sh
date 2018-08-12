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

# Execute the container CMD under tini for better hygiene
echo "Executing command: ${CMD[@]}" 1>&2
exec /sbin/tini -s -- "${CMD[@]}"
