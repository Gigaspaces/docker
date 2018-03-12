#!/bin/bash

if [ -z "$XAP_MANAGER_SERVERS" ]; then
	export XAP_MANAGER_SERVERS=$HOSTNAME
fi

/opt/gigaspaces/bin/insightedge $*
