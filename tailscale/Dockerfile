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
    # Check iptables binaries
    which iptables || true; \
    which ip6tables || true; \
    # Create symlinks if xtables-nft-multi exists
    if [ -x /sbin/xtables-nft-multi ]; then \
        ln -sf /sbin/xtables-nft-multi /sbin/ip6tables; \
        ln -sf /sbin/xtables-nft-multi /sbin/iptables; \
    fi; \
    # Map BUILD_ARCH to Tailscale download arch
    case "${BUILD_ARCH}" in \
        amd64) ARCH=amd64 ;; \
        aarch64) ARCH=arm64 ;; \
        armv7) ARCH=arm ;; \
        i386) ARCH=386 ;; \
        *) echo "Unknown arch: ${BUILD_ARCH}" && exit 1 ;; \
    esac; \
    # Download Tailscale tarball and extract
    curl -L -s \
        "https://pkgs.tailscale.com/stable/tailscale_${TAILSCALE_VERSION#v}_${ARCH}.tgz" \
      | tar zxvf - -C /opt/ --strip-components 1; \
    # Remove systemd folder if exists
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
    org.opencontainers.i
