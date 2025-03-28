# docker-snapcast

[![CI](https://github.com/florian-asche/docker-snapcast/actions/workflows/docker-build-release.yml/badge.svg)](https://github.com/florian-asche/docker-snapcast/actions/workflows/docker-build-release.yml) [![GitHub Package Version](https://img.shields.io/github/v/tag/florian-asche/docker-snapcast?label=version)](https://github.com/florian-asche/docker-snapcast/pkgs/container/docker-snapcast) [![GitHub License](https://img.shields.io/github/license/florian-asche/docker-snapcast)](https://github.com/florian-asche/docker-snapcast/blob/main/LICENSE) [![GitHub last commit](https://img.shields.io/github/last-commit/florian-asche/docker-snapcast)](https://github.com/florian-asche/docker-snapcast/commits) [![GitHub Container Registry](https://img.shields.io/badge/Container%20Registry-GHCR-blue)](https://github.com/florian-asche/docker-snapcast/pkgs/container/docker-snapcast)

This repository provides Docker images for [Snapcast](https://github.com/badaix/snapcast), a multi-room audio streaming solution. The images include both the Snapcast server and client components, allowing you to set up a synchronized audio streaming system across multiple devices.

## Features

- Pre-built Docker images for both Snapcast server and client
- Uses Pipewire-client for audio server connectivity
- Supports multiple architectures (linux/amd64 and linux/aarch64)
- Automated builds with artifact attestation for security

For Raspberry Pi users: Check out [PiCompose](https://github.com/florian-asche/PiCompose) for a Pi-Ready image with pipewire-server (audio-server).

## Usage

### Snapcast Server

**Home Assistant Integration**

If you're using [Home Assistant](https://www.home-assistant.io/) from [Nabu Casa](https://www.nabucasa.com/), we recommend using [Music Assistant](https://github.com/music-assistant/server) as a server in combination with snapcast client instead. It provides better integration and more features for audio streaming management in Home Assistant. An example configuration for the Snapcast server can be found in the `docker-compose_server.yml` file in this repository.

**How to run**

To run the Snapcast server:

```bash
docker run --rm -it ghcr.io/florian-asche/docker-snapcast:latest
```

### Snapcast Client

For a complete example configuration, check out the `docker-compose_client.yml` file in this repository.

To run the Snapcast client, specify the host ID and use the snapclient entrypoint:

```bash
docker run --rm -it \
  --network host \
  --device /dev/snd:/dev/snd \
  --device /dev/bus/usb \
  --group-add audio \
  -e START_SNAPCLIENT=true \
  -e PIPEWIRE_RUNTIME_DIR=/run \
  -e XDG_RUNTIME_DIR=/run \
  --volume /run/user/1000/pipewire-0:/run/pipewire-0 \
  --entrypoint=/usr/bin/snapclient \
  ghcr.io/florian-asche/docker-snapcast:latest \
  --host 192.168.33.5 \
  --hostID client1 \
  --soundcard pipewire
```

### Parameter Overview

| Parameter | Description |
|-----------|-------------|
| `--network host` | Uses the host's network stack for better audio streaming performance |
| `--device /dev/snd:/dev/snd` | Gives access to the host's sound devices |
| `--device /dev/bus/usb` | Enables access to USB audio devices |
| `--group-add audio` | Adds the container to the host's audio group for sound device access |
| `-e START_SNAPCLIENT=true` | Ensures the Snapcast client starts automatically |
| `-e PIPEWIRE_RUNTIME_DIR=/run` | Sets the Pipewire runtime directory |
| `-e XDG_RUNTIME_DIR=/run` | Sets the XDG runtime directory for Pipewire |
| `--volume /run/user/1000/pipewire-0:/run/pipewire-0` | Mounts the Pipewire socket for audio streaming |
| `--host <IP>` | IP address of the Snapcast server |
| `--hostID <name>` | Unique identifier for this client |
| `--soundcard pipewire` | Uses Pipewire as the audio backend |

## Build Information

Image builds can be tracked in this repository's `Actions` tab, and utilize [artifact attestation](https://docs.github.com/en/actions/security-guides/using-artifact-attestations-to-establish-provenance-for-builds) to certify provenance.

The Docker images are built using GitHub Actions, which provides:

- Automated builds for different architectures
- Artifact attestation for build provenance verification
- Regular updates and maintenance

### Available Tags

- `latest`: Latest stable release
- `nightly`: Builds from the main branch (may be unstable)
- Version-specific tags (e.g., `0.31.0-1__0.1`): Stable releases

### Build Process

The build process includes:

- Multi-architecture support (linux/amd64 and linux/aarch64)
- Security verification through artifact attestation
- Automated testing and validation
- Regular updates to maintain compatibility

For more information about the build process and available architectures, please refer to the Actions tab in this repository.
