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

### Available Docker Tags

- `latest`: Latest stable release
- `nightly`: Builds from the main branch (may be unstable)
- Version-specific tags (e.g., `0.31.0-1__0.1`): Stable releases

### Snapcast Server

**Home Assistant Integration**

If you're using [Home Assistant](https://www.home-assistant.io/) from [Nabu Casa](https://www.nabucasa.com/), we recommend using [Music Assistant](https://github.com/music-assistant/server) as a server in combination with snapcast client instead. It provides better integration and more features for audio streaming management in Home Assistant. An example configuration for the Snapcast server can be found in the `docker-compose_server.yml` file in this repository.

**How to run**

If you still want to run the snapcast server, check out the `docker-compose_server.yml` file:

```bash
docker compose -f docker-compose_server.yml up -d
```

### Snapcast Client

For a complete example configuration, check out the `docker-compose_client.yml` file in this repository.

To run the Snapcast client, copy `.env.example` to `.env` and configure your settings:

```bash
cp .env.example .env
# Edit .env with your configuration
docker compose -f docker-compose_client.yml up -d
```

### Configuration Parameters

The client uses environment variables for configuration. Copy `.env.example` to `.env` and customize:

| Parameter               | Description                                                          |
| ------------------------ | ---------------------------------------------------------------------- |
| `SC_USER_ID`            | User ID for audio device permissions (default: 1000)                 |
| `SC_USER_GROUP`         | User group ID for audio device permissions (default: 1000)            |
| `CLIENT_NAME`           | Optional custom name for this client                                 |
| `SC_PULSE_SERVER`       | PulseAudio/Pipewire socket path (default: unix:/run/user/1000/pulse/native) |
| `SC_XDG_RUNTIME_DIR`    | XDG runtime directory (default: /run/user/1000)                       |
| `SNAPCAST_REMOTE_HOST`  | Snapcast server URL (e.g., tcp://192.168.33.5)                        |
| `ENABLE_DEBUG`          | Enable debug mode (optional, set to "1" to enable)                   |

### Command Line Parameters

You can also pass parameters directly to snapclient:

```bash
# List available devices
--list
```

If you need more information about pipewire, you can find them here: [piCompose - Pipewire debugging](https://github.com/florian-asche/PiCompose/docs/pipewire_debugging.md)

## Build Information

Image builds can be tracked in this repository's `Actions` tab, and utilize [artifact attestation](https://docs.github.com/en/actions/security-guides/using-artifact-attestations-to-establish-provenance-for-builds) to certify provenance.

The Docker images are built using GitHub Actions, which provides:

- Automated builds for different architectures
- Artifact attestation for build provenance verification
- Regular updates and maintenance

### Build Process

The build process includes:

- Multi-architecture support (linux/amd64 and linux/aarch64)
- Security verification through artifact attestation
- Automated testing and validation
- Regular updates to maintain compatibility

For more information about the build process and available architectures, please refer to the Actions tab in this repository.
