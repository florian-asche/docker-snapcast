# Default parameters
ARG DEBIAN_VERSION=bookworm
#ARG SNAPCAST_VERSION1=0.31.0
#ARG SNAPCAST_VERSION2=0.31.0-1

FROM debian:${DEBIAN_VERSION}

ENV LANG C.UTF-8
ENV DEBIAN_FRONTEND=noninteractive

# Install audio dependencies
RUN apt-get update && \
    apt-get install --yes --no-install-recommends \
        curl \
        avahi-utils \
        alsa-utils \
        pulseaudio-utils \
        pipewire-bin \
        build-essential \
        libasound2-plugins \
        pipewire-alsa && \
    rm -rf /var/lib/apt/lists/*

# Install snapcast
RUN curl -vfL -o /tmp/snapserver.deb https://github.com/badaix/snapcast/releases/download/v${SNAPCAST_VERSION1}/snapserver_${SNAPCAST_VERSION2}_$(dpkg --print-architecture)_${DEBIAN_VERSION}.deb && \
    curl -vfL -o /tmp/snapclient.deb https://github.com/badaix/snapcast/releases/download/v${SNAPCAST_VERSION1}/snapclient_${SNAPCAST_VERSION2}_$(dpkg --print-architecture)_${DEBIAN_VERSION}.deb && \
    apt install -y /tmp/snapserver.deb /tmp/snapclient.deb && \
    rm -f /tmp/snapserver.deb /tmp/snapclient.deb && \
    rm -rf /var/lib/apt/lists/*

# Create and switch to non-root user
RUN useradd -m -s /bin/bash -u 1000 snapcast && \
    usermod -a -G audio snapcast
USER snapcast

# Set ports for snapcast
EXPOSE 1704 1705

# Set start script
ENTRYPOINT ["/usr/bin/snapserver"]
