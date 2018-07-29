FROM debian:stretch AS build
ARG MYTHTV_COMMIT=HEAD
ARG RECONFIGURE=false
ARG CONFIGURE_ARGS="--enable-libx264 \
        --enable-libxvid --enable-libfftw3 --enable-nonfree --enable-pic \
	--extra-cxxflags="-fno-devirtualize" \
	--enable-libmp3lame --enable-librtmp \
	--disable-ffprobe --disable-ffserver --enable-opengl-video --enable-vaapi --enable-crystalhd"

#RUN apt-get update && apt-get dist-upgrade -y

# locales is needed for the below because mythbe complains about $LANG not being *.UTF-8
# X bits are needed even for backend due to mythtv-setup.
RUN apt-get update && env DEBIAN_FRONTEND=noninteractive  apt-get install -y git locales \
	tigervnc-standalone-server evilwm xorg xinit

#ccache
#ENV PATH=/usr/lib/ccache/:$PATH

RUN sed -i -e 's/# en_GB.UTF-8 UTF-8/en_GB.UTF-8 UTF-8/' /etc/locale.gen && \
    dpkg-reconfigure --frontend=noninteractive locales && \
    update-locale
ENV LANG=en_GB.UTF-8

# Repository contains subdirectories `mythtv`, `mythplugins` etc, so clone as /src
RUN mkdir /src && git clone https://github.com/MythTV/MythTV /src && git -C /src checkout ${MYTHTV_COMMIT}
WORKDIR /src/mythtv

# XXX TODO try with just Debian sources and inline the build-deps?
RUN echo deb     http://mirror/debian-multimedia/ stretch main >> /etc/apt/sources.list
RUN echo deb-src http://mirror/debian-multimedia/ stretch main >> /etc/apt/sources.list
RUN apt-get update "-oAcquire::AllowInsecureRepositories=true" && apt-get install -y --allow-unauthenticated "-oAcquire::AllowInsecureRepositories=true" deb-multimedia-keyring
# libqt5sql5-mysql needed at runtime
# mysql-client is only needed for debug convenince
RUN apt-get update && apt-get build-dep -y mythtv-dmo && apt-get install -y libqt5sql5-mysql mysql-client

# Cache the baseline
RUN ./configure ${CONFIGURE_ARGS}
RUN make -j$(getconf _NPROCESSORS_ONLN)

# The above is a fresh build of ${MYTHTV_COMMIT} which should be
# cacheable. Now add local mods and rebuild (hopefully) just what
# changed.

ADD mythtv/ /src/mythtv/
ADD mythplugins/ /src/mythplugins/

# Only reconfigure if requested to preserve caching
RUN if [ "${RECONFIGURE}" = "true" ] ; then ./configure ${CONFIGURE_ARGS} ; fi
RUN make -j$(getconf _NPROCESSORS_ONLN)

RUN make install -j$(getconf _NPROCESSORS_ONLN) && /sbin/ldconfig

WORKDIR /src/mythplugins
RUN ./configure --enable-all
RUN make -j$(getconf _NPROCESSORS_ONLN)
RUN make install -j$(getconf _NPROCESSORS_ONLN) && /sbin/ldconfig

RUN useradd --system --create-home --home-dir /var/lib/mythtv mythtv
USER mythtv
WORKDIR /var/lib/mythtv
RUN mkdir /var/lib/mythtv/.vnc && echo mythtv | tigervncpasswd -f > /var/lib/mythtv/.vnc/passwd

FROM build as mythtvfrontend

# vnc :0
EXPOSE 5900/tcp
VOLUME /var/lib/mythtv

ADD docker/frontend.entrypoint /usr/local/bin/entrypoint
ENTRYPOINT /usr/local/bin/entrypoint

FROM build as mythtvbackend

# vnc :0
EXPOSE 5900/tcp
# mythbe ports
EXPOSE 6549/tcp 6543/tcp 6544/tcp 6543/tcp 6554/tcp
VOLUME /recordings
VOLUME /music
VOLUME /var/lib/mythtv

ADD docker/backend.entrypoint /usr/local/bin/entrypoint
#ADD docker/backend.config.xml /var/lib/mythtv/.mythtv/config.xml
ENTRYPOINT /usr/local/bin/entrypoint
