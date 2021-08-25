#!/bin/bash

if [ -z "$GS_MANAGER_SERVERS" ]; then
    if [ -z "$GS_PUBLIC_HOST"  ]; then
	    export GS_MANAGER_SERVERS=$HOSTNAME
    else
        export GS_MANAGER_SERVERS=$GS_PUBLIC_HOST
    fi
fi

/opt/gigaspaces/bin/gs.sh $*