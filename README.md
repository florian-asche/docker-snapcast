# docker-snapcast
Docker image for the [Snapcast](https://github.com/badaix/snapcast) server and client programs. This repository is independent form the original Snapcast project.

You can run the image as follows:
```
### snapserver is the default process, and may be run as follows for example:
docker run --rm -it ghcr.io/mvitale1989/snapcast:0.28.0-0

### If you'd like to run it in snapclient mode, you can run the container as follows:
docker run --rm -it --entrypoint=/usr/bin/snapclient ghcr.io/mvitale1989/snapcast:0.28.0-0 --hostID client1
```

Image builds can be tracked in this repository's `Actions` tab, and utilize [artifact attestation](https://docs.github.com/en/actions/security-guides/using-artifact-attestations-to-establish-provenance-for-builds) to certify provenance.
