FROM i386/debian:buster
#RUN apt-get update && apt-get dist-upgrade -y

RUN echo deb     [trusted=yes] http://mirror/debian-multimedia/ sid main >> /etc/apt/sources.list.d/dmo.list \
 && echo deb-src [trusted=yes] http://mirror/debian-multimedia/ sid main >> /etc/apt/sources.list.d/dmo.list
RUN apt-get update && apt-get install -y --allow-unauthenticated deb-multimedia-keyring

RUN rm -f /etc/apt/sources.list.d/dmo.list \
 && echo deb     http://mirror/debian-multimedia/ sid main >> /etc/apt/sources.list.d/dmo.list \
 && echo deb-src http://mirror/debian-multimedia/ sid main >> /etc/apt/sources.list.d/dmo.list

RUN apt-get update && apt-get install -y git less vim sudo

#RUN echo deb     http://mirror/debian/ buster main >> /etc/apt/sources.list
RUN apt-get update && apt-get build-dep -y -ai386 mythtv-dmo

RUN addgroup --gid 1000 ijc && adduser --system --quiet --disabled-login --uid 1000 --gid 1000 ijc && adduser ijc sudo && adduser ijc staff
RUN echo ijc ALL=NOPASSWD: ALL >> /etc/sudoers
USER 1000

RUN echo alias run-configure=\'./configure --enable-libx264 \
        --enable-libxvid --enable-libfftw3 --enable-nonfree --enable-pic \
        --extra-cxxflags="-fno-devirtualize" \
        --enable-libmp3lame --enable-librtmp \
        --disable-ffprobe --disable-ffserver --enable-opengl-video --enable-vaapi --enable-crystalhd\' \
	>>/home/ijc/.bash_profile
WORKDIR /src
