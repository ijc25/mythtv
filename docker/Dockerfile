FROM mcandre/docker-debian-32bit:stretch
RUN apt-get update && apt-get dist-upgrade -y
RUN echo deb     http://mirror/debian-multimedia/ sid main >> /etc/apt/sources.list
RUN echo deb-src http://mirror/debian-multimedia/ sid main >> /etc/apt/sources.list
RUN apt-get update && apt-get install -y --allow-unauthenticated deb-multimedia-keyring
RUN apt-get update && apt-get install -y git less vim sudo
RUN echo deb     http://mirror/debian/ buster main >> /etc/apt/sources.list
RUN apt-get update && apt-get build-dep -y -ai386 mythtv-dmo
RUN addgroup --gid 1000 ijc && adduser --system --quiet --disabled-login --uid 1000 --gid 1000 ijc && adduser ijc sudo && adduser ijc staff
RUN echo ijc ALL=NOPASSWD: ALL >> /etc/sudoers
USER 1000
WORKDIR /src
