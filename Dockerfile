# syntax=docker/dockerfile:1

FROM alpine:3.15 as builder

LABEL org.opencontainers.image.source=https://github.com/altertek/docker-ooni-probe
LABEL org.opencontainers.image.authors=Altertek

ARG PROBEVERSION=v3.14.2
ARG TARGETPLATFORM
ENV TARGETPLATFORM=${TARGETPLATFORM:-"linux/amd64"}

SHELL ["/bin/ash", "-eo", "pipefail", "-c"]

RUN apk add --no-cache wget \
    && ARCH=$(echo $TARGETPLATFORM | tr / -) \
    && wget -q --output-document=/root/probe.bin \
	"https://github.com/ooni/probe-cli/releases/download/$PROBEVERSION/ooniprobe-$ARCH" \
    && chmod +x /root/probe.bin

FROM alpine:3.15

ARG USER=default
ENV HOME /home/$USER

COPY --from=builder /root/probe.bin /usr/bin/ooniprobe

RUN adduser -D -g $USER $USER \
    && su $USER -c "/usr/bin/ooniprobe onboard --yes" \
    && chmod -R 777 "$HOME/.ooniprobe"

USER $USER
WORKDIR $HOME

CMD ["/usr/bin/ooniprobe", "run", "unattended", "--batch"]
