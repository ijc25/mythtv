#!/bin/bash
set -ex

if [ $# -eq 0 ] ; then
	set -- bash -l
fi
#if [ ! -f docker/buildenv32.iid ] ; then
# rely on Docker cache.
	tar -cf - docker/buildenv32.Dockerfile | docker build -f docker/buildenv32.Dockerfile --iidfile=docker/buildenv32.iid -t mythtv:buildenv32 -
#fi
iid=$(cat docker/buildenv32.iid) # mythtv:dev
docker run --privileged -it --rm  -v `pwd`:/src $iid $@
#make -C /src/mythtv/libs/libmythmetadata
#rsync -aHSv mythtv/libs/libmythmetadata/libmythmetadata-0.28.so* iranon:/tmp

