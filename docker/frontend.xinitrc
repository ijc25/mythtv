#!/bin/bash

set -x

#evilwm &

if [ -z "$MYTHTV_FRONTEND" ] ; then
	exec /usr/local/bin/mythfrontend
else
	exec $MYTHTV_FRONTEND
fi

