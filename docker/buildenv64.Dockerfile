FROM debian:buster
#RUN apt-get update && apt-get dist-upgrade -y

RUN echo deb     [trusted=yes] http://mirror/debian-multimedia/ buster main >> /etc/apt/sources.list.d/dmo.list \
 && echo deb-src [trusted=yes] http://mirror/debian-multimedia/ buster main >> /etc/apt/sources.list.d/dmo.list
RUN apt-get update && apt-get install -y --allow-unauthenticated deb-multimedia-keyring

RUN rm -f /etc/apt/sources.list.d/dmo.list \
 && echo deb     http://mirror/debian-multimedia/ buster main >> /etc/apt/sources.list.d/dmo.list \
 && echo deb-src http://mirror/debian-multimedia/ buster main >> /etc/apt/sources.list.d/dmo.list

RUN apt-get update && apt-get install -y git less vim sudo gdb strace

RUN apt-get update && apt-get build-dep -y -aamd64 mythtv-dmo && apt-get install -y libqt5sql5-mysql

RUN addgroup --gid 1000 ijc && adduser --system --quiet --disabled-login --uid 1000 --gid 1000 ijc && adduser ijc sudo && adduser ijc staff
RUN echo ijc ALL=NOPASSWD: ALL >> /etc/sudoers
USER 1000

# DISPLAY=:0
# LD_LIBRARY_PATH=$(echo `pwd`/./external/FFmpeg/* `pwd`/libs/* | tr ' ' ':') ./programs/mythavtest/mythavtest http://hhhshop.co:83/live/WXPh3eF3/TEAn894m/304115.m3u8
RUN echo alias run-configure=\'./configure --enable-libx264 --prefix=/usr --libdir-name=lib/x86_64-linux-gnu \
        --enable-libxvid --enable-libfftw3 --enable-nonfree --enable-pic \
        --extra-cxxflags="-fno-devirtualize" \
        --enable-libmp3lame --disable-xnvctrl \
        --disable-ffprobe --disable-ffserver --enable-opengl-video --enable-vaapi --disable-crystalhd\' \
	>>/home/ijc/.bash_profile

#<Configuration>
#  <LocalHostName>hastur</LocalHostName>
#  <Database>
#    <PingHost>1</PingHost>
#    <Host>192.168.1.4</Host>
#    <UserName>mythtv</UserName>
#    <Password>WqBpm8dr</Password>
#    <DatabaseName>mythconverg</DatabaseName>
#    <Port>3306</Port>
#  </Database>
#  <WakeOnLAN>
#    <Enabled>0</Enabled>
#    <SQLReconnectWaitTime>0</SQLReconnectWaitTime>
#    <SQLConnectRetry>5</SQLConnectRetry>
#    <Command>echo 'WOLsqlServerCommand not set'</Command>
#  </WakeOnLAN>
#</Configuration>

WORKDIR /src
