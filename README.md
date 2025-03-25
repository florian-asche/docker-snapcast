# docker-snapcast

This repository provides Docker images for [Snapcast](https://github.com/badaix/snapcast), a multi-room audio streaming solution. The images include both the Snapcast server and client components, allowing you to set up a synchronized audio streaming system across multiple devices.

## Features

- Pre-built Docker images for both Snapcast server and client
- Uses Pipewire-client for audio server connectivity
- Supports multiple architectures (linux/amd64 and linux/aarch64)
- Automated builds with artifact attestation for security

For Raspberry Pi users: Check out [PiCompose](https://github.com/florian-asche/PiCompose) for Pi-ready image with pipewire-server.

## Usage

### Snapcast Server

To run the Snapcast server:

```bash
docker run --rm -it ghcr.io/florian-asche/docker-snapcast:0.31.0-1
```

### Snapcast Client

To run the Snapcast client, specify the host ID and use the snapclient entrypoint:

```bash
docker run --rm -it --entrypoint=/usr/bin/snapclient ghcr.io/florian-asche/docker-snapcast:0.31.0-1 --hostID client1
```

## Build Information

Image builds can be tracked in this repository's `Actions` tab, and utilize [artifact attestation](https://docs.github.com/en/actions/security-guides/using-artifact-attestations-to-establish-provenance-for-builds) to certify provenance.

The Docker images are built using GitHub Actions, which provides:
- Automated builds for different architectures
- Artifact attestation for build provenance verification
- Regular updates and maintenance

### Available Tags

- `latest`: Latest stable release
- `nightly`: Builds from the main branch (may be unstable)
- Version-specific tags (e.g., `0.31.0-1`): Stable releases

### Build Process

The build process includes:
- Multi-architecture support (linux/amd64 and linux/aarch64)
- Security verification through artifact attestation
- Automated testing and validation
- Regular updates to maintain compatibility

For more information about the build process and available architectures, please refer to the Actions tab in this repository.
