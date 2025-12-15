# Default base if BUILD_FROM not set
ARG BUILD_FROM=ghcr.io/hassio-addons/base/amd64:19.0.0
FROM ${BUILD_FROM}

# Build arguments
ARG BUILD_ARCH
ARG TAILSCALE_VERSION
ARG BUILD_DATE
ARG BUILD_DESCRIPTION
ARG BUILD_NAME
ARG BUILD_REF
ARG BUILD_REPOSITORY
ARG BUILD_VERSION

# Set shell
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Setup base and install dependencies
RUN set -eux; \
    apk add --no-cache \
        ethtool \
        ipcalc \
        iproute2 \
        iptables \
        nginx \
        coreutils \
        networkmanager \
        curl; \
    echo "APK OK"; \
    ls -l /sbin || true; \
    ls -l /usr/sbin || true; \
    which iptables || true; \
    which ip6tables || true; \
    if [ -x /sbin/xtables-nft-multi ]; then \
        ln -sf /sbin/xtables-nft-multi /sbin/ip6tables; \
        ln -sf /sbin/xtables-nft-multi /sbin/iptables; \
    fi; \
    case "${BUILD_ARCH}" in \
        aarch64) ARCH=arm64 ;; \
        armv7)   ARCH=arm ;; \
        amd64)   ARCH=amd64 ;; \
        *) echo "Unknown arch: ${BUILD_ARCH}" && exit 1 ;; \
    esac; \
    curl -L -s \
        "https://pkgs.tailscale.com/stable/tailscale_${TAILSCALE_VERSION#v}_${ARCH}.tgz" \
      | tar zxvf - -C /opt/ --strip-components 1; \
    rm -rf /opt/systemd

# Copy root filesystem
COPY rootfs /

# Healthcheck
HEALTHCHECK CMD healthcheck

# S6 Overlay stage 2 hook
ENV S6_STAGE2_HOOK=/etc/s6-overlay/scripts/stage2_hook.sh

# Labels
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
