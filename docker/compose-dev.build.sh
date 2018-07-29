#!/bin/bash
set -e -x

: ${MYTHTV_REF:=HEAD}
#: ${MYTHTV_COMMIT:=$(git rev-parse ${MYTHTV_REF})}
: ${MYTHTV_COMMIT:=$(git merge-base ${MYTHTV_REF} origin/master)}

case ${1:-both} in
    frontend|both)
	docker build --force-rm --build-arg MYTHTV_COMMIT=${MYTHTV_COMMIT} --target mythtvfrontend -f docker/compose-dev.Dockerfile -t mythtvfrontend:compose-dev .
	;;
esac
case ${1:-both} in
    backend|both)
	docker build --force-rm --build-arg MYTHTV_COMMIT=${MYTHTV_COMMIT} --target mythtvbackend -f docker/compose-dev.Dockerfile -t mythtvbackend:compose-dev .
	;;
esac
