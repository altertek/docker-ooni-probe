# syntax=docker/dockerfile:1

FROM alpine:3.22 AS builder

LABEL org.opencontainers.image.source=https://github.com/altertek/docker-ooni-probe
LABEL org.opencontainers.image.authors=Altertek

ARG PROBEVERSION=v3.27.0
ARG TARGETPLATFORM
ENV TARGETPLATFORM=${TARGETPLATFORM:-"linux/amd64"}

SHELL ["/bin/ash", "-eo", "pipefail", "-c"]

RUN apk add --no-cache wget \
    && ARCH=$(echo $TARGETPLATFORM | tr / -) \
    && wget -q --output-document=/root/probe.bin \
	"https://github.com/ooni/probe-cli/releases/download/$PROBEVERSION/ooniprobe-$ARCH" \
    && chmod +x /root/probe.bin

FROM alpine:3.22

ARG USER=default
ENV HOME=/home/$USER

COPY --from=builder /root/probe.bin /usr/bin/ooniprobe

RUN adduser -D -g $USER $USER \
    && chown -R $USER:$USER $HOME

USER $USER
WORKDIR $HOME

RUN /usr/bin/ooniprobe onboard --yes

CMD ["/usr/bin/ooniprobe", "run", "unattended", "--batch"]
