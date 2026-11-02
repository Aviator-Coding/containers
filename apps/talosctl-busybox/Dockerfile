# syntax=docker/dockerfile:1
# Busybox plus the talosctl binary: the init container of the home-ops ARC
# runner scale set copies talosctl out of it so image-pull jobs can talk to the
# nodes. VERSION is the ghcr.io/siderolabs/talosctl tag (docker-bake.hcl).
ARG VERSION=v1.14.5
FROM ghcr.io/siderolabs/talosctl:${VERSION} AS talosctl

FROM busybox:1.38

ARG VERSION
LABEL org.opencontainers.image.description="Busybox with talosctl ${VERSION}"

COPY --from=talosctl /talosctl /usr/local/bin/talosctl
