# Default parameters
ARG DEBIAN_VERSION=trixie
ARG SNAPCAST_VERSION1
ARG SNAPCAST_VERSION2

FROM debian:${DEBIAN_VERSION}
ARG DEBIAN_VERSION
ARG SNAPCAST_VERSION1
ARG SNAPCAST_VERSION2

ENV LANG=C.UTF-8
ENV DEBIAN_FRONTEND=noninteractive

LABEL \
    org.opencontainers.image.authors="Florian Asche" \
    org.opencontainers.image.description="Snapcast client and server" \
    org.opencontainers.image.documentation="https://github.com/florian-asche/docker-snapcast/blob/main/README.md" \
    org.opencontainers.image.licenses="GNU General Public License v3.0" \
    org.opencontainers.image.source="https://github.com/florian-asche/docker-snapcast" \
    org.opencontainers.image.title="Snapcast" \
    org.opencontainers.image.url="https://github.com/florian-asche/docker-snapcast"

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
        pipewire-alsa \
        ca-certificates

# Install snapcast
RUN echo https://github.com/badaix/snapcast/releases/download/v${SNAPCAST_VERSION1}/snapserver_${SNAPCAST_VERSION2}_$(dpkg --print-architecture)_${DEBIAN_VERSION}.deb && \
    echo https://github.com/badaix/snapcast/releases/download/v${SNAPCAST_VERSION1}/snapclient_${SNAPCAST_VERSION2}_$(dpkg --print-architecture)_${DEBIAN_VERSION}.deb
RUN curl -vfL -o /tmp/snapserver.deb https://github.com/badaix/snapcast/releases/download/v${SNAPCAST_VERSION1}/snapserver_${SNAPCAST_VERSION2}_$(dpkg --print-architecture)_${DEBIAN_VERSION}.deb && \
    curl -vfL -o /tmp/snapclient.deb https://github.com/badaix/snapcast/releases/download/v${SNAPCAST_VERSION1}/snapclient_${SNAPCAST_VERSION2}_$(dpkg --print-architecture)_${DEBIAN_VERSION}.deb && \
    apt install -y /tmp/snapserver.deb /tmp/snapclient.deb && \
    rm -f /tmp/snapserver.deb /tmp/snapclient.deb && \
    rm -rf /var/lib/apt/lists/* && \
    apt-get clean all

# Create and switch to non-root user
RUN useradd -m -s /bin/bash -u 1000 snapcast && \
    usermod -a -G audio snapcast
USER snapcast

# Set ports for snapcast
EXPOSE 1704 1705

# Set start script
ENTRYPOINT ["/usr/bin/snapserver"]
