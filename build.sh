#!/bin/bash
set -ex

export DOCKER_BUILDKIT=1
if [ $# -eq 0 ] ; then
	set -- bash -l
fi
docker build --iidfile=docker/buildenv64.iid -f docker/compose-dev.Dockerfile --target=build-env .
iid=$(cat docker/buildenv64.iid)
docker run --privileged -it --rm  -v `pwd`:/src $iid $@
