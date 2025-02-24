ARG DEBIAN_VERSION=bookworm
ARG SNAPCAST_VERSION1=0.29.0
ARG SNAPCAST_VERSION2=0.29.0-1

FROM debian:${DEBIAN_VERSION}
ARG DEBIAN_VERSION
ARG SNAPCAST_VERSION1
ARG SNAPCAST_VERSION2
RUN apt-get update && apt-get install -y curl avahi-utils alsa-utils pulseaudio-utils pipewire-bin build-essential libasound2-plugins pipewire-alsa
RUN curl -vfL -o /tmp/snapserver.deb https://github.com/badaix/snapcast/releases/download/v${SNAPCAST_VERSION1}/snapserver_${SNAPCAST_VERSION2}_$(dpkg --print-architecture)_${DEBIAN_VERSION}.deb && \
    curl -vfL -o /tmp/snapclient.deb https://github.com/badaix/snapcast/releases/download/v${SNAPCAST_VERSION1}/snapclient_${SNAPCAST_VERSION2}_$(dpkg --print-architecture)_${DEBIAN_VERSION}.deb && \
    apt install -y /tmp/snapserver.deb /tmp/snapclient.deb
RUN rm -rf /var/lib/apt/lists/*

RUN useradd -m -s /bin/bash -u 1000 debian
USER  debian
WORKDIR /home/debian
ENTRYPOINT ["/usr/bin/snapserver"]
