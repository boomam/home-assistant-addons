ARG BUILD_FROM

FROM $BUILD_FROM

ARG BUILD_ARCH
ARG PANGOLIN_CLI_VERSION

# PANGOLIN_CLI version visibility
ENV PANGOLIN_CLI_VERSION=${PANGOLIN_CLI_VERSION}

# PANGOLIN_CLI health file
ENV HEALTH_FILE=/tmp/healthy

# Dependancies
RUN apk add --no-cache bash curl jq

# Download PANGOLIN_CLI, by Arch
# Detect system architecture and download the correct PANGOLIN_CLI binary
RUN ARCH=$(uname -m) && \
    if [ "$ARCH" = "x86_64" ]; then \
        curl -fsSL -o /usr/bin/pangolin-cli https://github.com/fosrl/pangolin-cli/releases/download/${PANGOLIN_CLI_VERSION}/pangolin-cli_linux_amd64; \
    elif [ "$ARCH" = "aarch64" ]; then \
        curl -fsSL -o /usr/bin/pangolin-cli https://github.com/fosrl/pangolin-cli/releases/download/${PANGOLIN_CLI_VERSION}/pangolin-cli_linux_arm64; \
    elif [ "$ARCH" = "armv7l" ]; then \
        curl -fsSL -o /usr/bin/pangolin-cli https://github.com/fosrl/pangolin-cli/releases/download/${PANGOLIN_CLI_VERSION}/pangolin-cli_linux_arm32; \
    elif [ "$ARCH" = "armv6l" ]; then \
        curl -fsSL -o /usr/bin/pangolin-cli https://github.com/fosrl/pangolin-cli/releases/download/${PANGOLIN_CLI_VERSION}/pangolin-cli_linux_arm32v6; \
    else \
        echo "ERROR: Unsupported architecture: $ARCH"; exit 1; \
    fi && \
    chmod +x /usr/bin/pangolin-cli

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
    io.hass.name="PANGOLIN_CLI for ${BUILD_ARCH}" \
    io.hass.description="Home Assistant Unofficial Add-on: ${BUILD_ARCH} PANGOLIN_CLI image" \
    maintainer="BoomAM" \
    org.opencontainers.image.title="Pangolin-CLI ${BUILD_ARCH}" \
    org.opencontainers.image.description="Home Assistant Unofficial Add-on: ${BUILD_ARCH} Pangolin-CLI image" \
    org.opencontainers.image.vendor="BoomAM" \
    org.opencontainers.image.authors="BoomAM" \
    org.opencontainers.image.url="https://github.com/boomam/home-assistant-addons" \
    org.opencontainers.image.source="https://github.com/boomam/home-assistant-addons" \
    org.opencontainers.image.documentation="https://github.com/boomam/home-assistant-addons/blob/master/pangolin-cli/README.md" \
    org.opencontainers.image.created=${BUILD_DATE} \
    org.opencontainers.image.revision=${BUILD_REF} \
    org.opencontainers.image.version=${BUILD_VERSION}