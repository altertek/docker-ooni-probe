# syntax=docker/dockerfile:1

FROM debian:bullseye-slim

LABEL org.opencontainers.image.source=https://github.com/altertek/docker-ooni-probe
LABEL org.opencontainers.image.authors=Altertek

ARG DEBIAN_FRONTEND=noninteractive

# hadolint ignore=DL3008
RUN apt-get update -y \
    && apt-get install gnupg --no-install-recommends -y \
    && apt-key adv --verbose --keyserver hkp://keyserver.ubuntu.com --recv-keys 'B5A08F01796E7F521861B449372D1FF271F2DD50' \
    && echo "deb http://deb.ooni.org/ unstable main" > /etc/apt/sources.list.d/ooniprobe.list \
    && apt-get update -y \
    && apt-get install ooniprobe-cli=3.14.1 --no-install-recommends -y \
    && rm -rf /var/lib/apt/lists/* \
    && /usr/bin/ooniprobe onboard --yes

COPY ooniprobe.conf /etc/ooniprobe/ooniprobe.conf

CMD ["/usr/bin/ooniprobe", "run", "unattended", "--batch"]
