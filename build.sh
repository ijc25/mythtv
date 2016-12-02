#!/bin/bash
set -ex
docker run --privileged -it --rm  -v `pwd`:/src mythtv:dev $@
#make -C /src/mythtv/libs/libmythmetadata
#rsync -aHSv mythtv/libs/libmythmetadata/libmythmetadata-0.28.so* iranon:/tmp

