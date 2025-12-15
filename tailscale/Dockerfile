ARG BUILD_FROM

FROM $BUILD_FROM

ARG BUILD_ARCH
ARG TAILSCALE_VERSION

# Set shell
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Setup base
ARG BUILD_ARCH=${BUILD_ARCH}
ARG TAILSCALE_VERSION=${TAILSCALE_VERSION}
RUN \
    apk add --no-cache \
        ethtool=6.14.1-r0 \
        ipcalc=1.0.3-r0 \
        iproute2=6.15.0-r0 \
        iptables=1.8.11-r1 \
        nginx=1.28.0-r3 \
        coreutils=9.7-r1 \
        networkmanager=1.52.1-r0 \
    \
    && ln -sf /sbin/xtables-nft-multi /sbin/ip6tables \
    && ln -sf /sbin/xtables-nft-multi /sbin/iptables \
    \
    && if [ "${BUILD_ARCH}" = "aarch64" ]; then ARCH="arm64"; fi \
    && if [ "${BUILD_ARCH}" = "armv7" ]; then ARCH="arm"; fi \
    && if [ "${BUILD_ARCH}" = "amd64" ]; then ARCH="amd64"; fi \
    \
    && curl -L -s \
        "https://pkgs.tailscale.com/stable/tailscale_${TAILSCALE_VERSION#v}_${ARCH}.tgz" \
        | tar zxvf - -C /opt/ --strip-components 1 \
    \
    && rm -f -r \
        /opt/systemd

# Copy root filesystem
COPY rootfs /

HEALTHCHECK \
    CMD healthcheck

# S6 Overlay stage 2 hook
ENV S6_STAGE2_HOOK=/etc/s6-overlay/scripts/stage2_hook.sh

# Build arguments
ARG BUILD_ARCH
ARG BUILD_DATE
ARG BUILD_DESCRIPTION
ARG BUILD_NAME
ARG BUILD_REF
ARG BUILD_REPOSITORY
ARG BUILD_VERSION

LABEL \
    io.hass.name="Tailscale for ${BUILD_ARCH}" \
    io.hass.description="Home Assistant Unofficial Add-on: ${BUILD_ARCH} Tailscale image" \
    maintainer="BoomAM" \
    org.opencontainers.image.title="Tailscale for ${BUILD_ARCH}" \
    org.opencontainers.image.description="Home Assistant Unofficial Add-on: ${BUILD_ARCH} Tailscale image" \
    org.opencontainers.image.vendor="BoomAM" \
    org.opencontainers.image.authors="BoomAM" \
    org.opencontainers.image.url="https://github.com/boomam/home-assistant-addons" \
    org.opencontainers.image.source="https://github.com/boomam/home-assistant-addons" \
    org.opencontainers.image.documentation="https://github.com/boomam/home-assistant-addons/blob/master/tailscale/README.md" \
    org.opencontainers.image.created=${BUILD_DATE} \
    org.opencontainers.image.revision=${BUILD_REF} \
    org.opencontainers.image.version=${BUILD_VERSION}