# OONI Probe Docker image

This repository contains the source to build an image for the [OONI Probe](https://github.com/ooni/probe) made by the wonderful people at OONI (https://ooni.org/)

The Open Observatory of Network Interference (OONI) is a non-profit free software project that aims to empower decentralized efforts in documenting Internet censorship around the world.

The source of the probe package is located on the ooni repository: https://github.com/ooni/probe-cli

## Quick start
```
docker run --rm -it --user default altertek/ooni-probe /usr/bin/ooniprobe run unattended
```

If you prefer the Github container registry:
```
docker run --rm -it --user default ghcr.io/altertek/ooni-probe /usr/bin/ooniprobe run unattended 
```

## How to run as daemon
You can use any container orchestration tool, for small deployments you can use the provided docker-compose file:
```
docker-compose up -d
```

## Container specifics
This is the default startup command this container runs if none is specified:
```
/usr/bin/ooniprobe run unattended --batch
```
`--batch` outputs results in JSON format, easier to parse if you have any log collector

### Light
The image is designed to be as minimalistic as possible (around 50 MB, we use alpine as base image)

### Security
The container is rootless by default

## Contributing
Please see https://github.com/altertek/.github/blob/main/CONTRIBUTING.md
