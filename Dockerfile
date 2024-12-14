ARG DEBIAN_VERSION=bookworm
ARG SNAPCAST_VERSION=0.29.0

FROM debian:${DEBIAN_VERSION}
ARG DEBIAN_VERSION
ARG SNAPCAST_VERSION
RUN apt-get update && apt-get install -y curl
RUN curl -vfL -o /tmp/snapserver.deb https://github.com/badaix/snapcast/releases/download/v${SNAPCAST_VERSION}/snapserver_${SNAPCAST_VERSION}-1_$(dpkg --print-architecture)_${DEBIAN_VERSION}.deb && \
    curl -vfL -o /tmp/snapclient.deb https://github.com/badaix/snapcast/releases/download/v${SNAPCAST_VERSION}/snapclient_${SNAPCAST_VERSION}-1_$(dpkg --print-architecture)_${DEBIAN_VERSION}.deb && \
    apt install -y /tmp/snapserver.deb /tmp/snapclient.deb
RUN rm -rf /var/lib/apt/lists/*

RUN useradd -m -s /bin/bash -u 1000 debian
USER  debian
WORKDIR /home/debian
ENTRYPOINT ["/usr/bin/snapserver"]
