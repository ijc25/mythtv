#!/bin/bash
set -ex

if [ $# -eq 0 ] ; then
	set -- bash -l
fi
#if [ ! -f docker/buildenv64.iid ] ; then
# rely on Docker cache.
	tar -cf - docker/buildenv64.Dockerfile | docker build -f docker/buildenv64.Dockerfile --iidfile=docker/buildenv64.iid -t mythtv:buildenv64 -
#fi
iid=$(cat docker/buildenv64.iid) # mythtv:dev
docker run --privileged --net=host -it --rm  -v `pwd`:/src $iid $@
#make -C /src/mythtv/libs/libmythmetadata
#rsync -aHSv mythtv/libs/libmythmetadata/libmythmetadata-0.28.so* iranon:/tmp
