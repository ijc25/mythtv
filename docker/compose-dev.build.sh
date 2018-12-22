#!/bin/bash
set -e -x
: ${MYTHTV_REF:=HEAD}
#: ${MYTHTV_COMMIT:=$(git rev-parse ${MYTHTV_REF})}
: ${MYTHTV_COMMIT:=$(git merge-base ${MYTHTV_REF} origin/master)}

PROGRESS=--progress=plain
#FORCE_RM= --force-rm
#RECONFIGURE=--build-arg=RECONFIGURE=true
case ${1:-both} in
    frontend|both)
	docker build $PROGRESS $FORCE_RM --build-arg MYTHTV_COMMIT=${MYTHTV_COMMIT} ${RECONFIGURE} --target mythtvfrontend -f docker/compose-dev.Dockerfile -t mythtvfrontend:compose-dev .
	;;
esac
case ${1:-both} in
    backend|both)
	docker build $PROGRESS $FORCE_RM --build-arg MYTHTV_COMMIT=${MYTHTV_COMMIT} ${RECONFIGURE} --target mythtvbackend -f docker/compose-dev.Dockerfile -t mythtvbackend:compose-dev .
	;;
esac
