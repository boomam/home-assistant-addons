ARG BUILD_FROM

FROM $BUILD_FROM

ARG BUILD_ARCH
ARG NEWT_VERSION

# Newt version visibility
ENV NEWT_VERSION=${NEWT_VERSION}

# Newt health file
ENV HEALTH_FILE=/tmp/healthy

# Dependancies
RUN apk add --no-cache bash curl jq

# Download Newt, by Arch
# Detect system architecture and download the correct Newt binary
RUN ARCH=$(uname -m) && \
    if [ "$ARCH" = "x86_64" ]; then \
        curl -fsSL -o /usr/bin/newt https://github.com/fosrl/newt/releases/download/${NEWT_VERSION}/newt_linux_amd64; \
    elif [ "$ARCH" = "aarch64" ]; then \
        curl -fsSL -o /usr/bin/newt https://github.com/fosrl/newt/releases/download/${NEWT_VERSION}/newt_linux_arm64; \
    elif [ "$ARCH" = "armv7l" ]; then \
        curl -fsSL -o /usr/bin/newt https://github.com/fosrl/newt/releases/download/${NEWT_VERSION}/newt_linux_arm32; \
    elif [ "$ARCH" = "armv6l" ]; then \
        curl -fsSL -o /usr/bin/newt https://github.com/fosrl/newt/releases/download/${NEWT_VERSION}/newt_linux_arm32v6; \
    else \
        echo "ERROR: Unsupported architecture: $ARCH"; exit 1; \
    fi && \
    chmod +x /usr/bin/newt

# Copy run script & add execute
COPY run.sh /run.sh
RUN chmod +x /run.sh 

# Docker healthcheck
HEALTHCHECK --interval=5s --timeout=2s --retries=2 --start-period=10s \
  CMD test -f /tmp/healthy || exit 1

# Start the add-on
ENTRYPOINT ["/run.sh"]

# Labels
LABEL \
    io.hass.name="Newt for ${BUILD_ARCH}" \
    io.hass.description="Home Assistant Unofficial Add-on: ${BUILD_ARCH} Newt image" \
    maintainer="BoomAM" \
    org.opencontainers.image.title="Newt ${BUILD_ARCH}" \
    org.opencontainers.image.description="Home Assistant Unofficial Add-on: ${BUILD_ARCH} Newt image" \
    org.opencontainers.image.vendor="BoomAM" \
    org.opencontainers.image.authors="BoomAM" \
    org.opencontainers.image.url="https://github.com/boomam/home-assistant-addons" \
    org.opencontainers.image.source="https://github.com/boomam/home-assistant-addons" \
    org.opencontainers.image.documentation="https://github.com/boomam/home-assistant-addons/blob/master/newt/README.md" \
    org.opencontainers.image.created=${BUILD_DATE} \
    org.opencontainers.image.revision=${BUILD_REF} \
    org.opencontainers.image.version=${BUILD_VERSION}