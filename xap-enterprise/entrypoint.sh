#!/bin/bash

if [ -z "$XAP_MANAGER_SERVERS" ]; then
    if [ -z "$XAP_PUBLIC_HOST"  ]; then
	    export XAP_MANAGER_SERVERS=$HOSTNAME
    else
        export XAP_MANAGER_SERVERS=$XAP_PUBLIC_HOST
    fi
fi

/opt/gigaspaces/bin/xap $*