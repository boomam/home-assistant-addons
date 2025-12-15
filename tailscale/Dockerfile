# Use dynamic build base
ARG BUILD_FROM=alpine:3.23
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

# Make them available inside RUN commands
ENV TAILSCALE_VERSION=${TAILSCALE_VERSION}
ENV BUILD_ARCH=${BUILD_ARCH}

# Set shell
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Install dependencies and Tailscale
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
    # Map BUILD_ARCH to Tailscale download architecture
    case "${BUILD_ARCH}" in \
        amd64) ARCH=amd64 ;; \
        aarch64) ARCH=arm64 ;; \
        armv7) ARCH=arm ;; \
        i386) ARCH=386 ;; \
        *) echo "Unknown BUILD_ARCH: ${BUILD_ARCH}" && exit 1 ;; \
    esac; \
    # Download Tailscale tarball safely
    curl -fSL "https://pkgs.tailscale.com/stable/tailscale_${TAILSCALE_VERSION}_${ARCH}.tgz" \
        | tar zxvf - -C /opt/ --strip-components 1

# Copy root filesystem
COPY rootfs /

# Make the stage2_hook executable
#RUN chmod +x /etc/s6-overlay/scripts/*.sh

# Make s6-overlay scripts and commands executable
RUN find /etc/s6-overlay/scripts /etc/s6-overlay/s6-rc.d -type f -name "*.sh" -exec chmod +x {} \; \
    && find /etc/s6-overlay/s6-rc.d -type f -name "run" -exec chmod +x {} \; \
    && find /etc/s6-overlay/s6-rc.d -type f -name "finish" -exec chmod +x {} \; \
    && chmod +x /command/subnet-routes

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
    org.opencontainers.image.created="${BUILD_DATE}" \
    org.opencontainers.image.revision="${BUILD_REF}" \
    org.opencontainers.image.version="${BUILD_VERSION}"
