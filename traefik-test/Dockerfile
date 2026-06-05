ARG BUILD_FROM

FROM $BUILD_FROM

ARG BUILD_ARCH
ARG TRAEFIK_VERSION

RUN if [ "${BUILD_ARCH}" == "aarch64" ]; then BUILD_ARCH=arm64; \
    elif [ "${BUILD_ARCH}" == "i386" ]; then BUILD_ARCH=386; \
    elif [ "${BUILD_ARCH}" == "armhf" ]; then BUILD_ARCH=armv7; \
    fi && \
    apk add --no-cache nginx gomplate && \
    # Star of logic to verify SHA256 of Traefik during dewnload
    TRAEFIK_ARTIFACT="traefik_v${TRAEFIK_VERSION}_linux_${BUILD_ARCH}.tar.gz" && \
    TRAEFIK_RELEASE_URL="https://github.com/traefik/traefik/releases/download/v${TRAEFIK_VERSION}" && \
    cd /tmp && \
    wget --quiet -O "${TRAEFIK_ARTIFACT}" "${TRAEFIK_RELEASE_URL}/${TRAEFIK_ARTIFACT}" && \
    wget --quiet -O traefik_checksums.txt "${TRAEFIK_RELEASE_URL}/traefik_v${TRAEFIK_VERSION}_checksums.txt" && \
    grep "  ${TRAEFIK_ARTIFACT}\$" traefik_checksums.txt | sha256sum -c - && \
    tar xzvf "${TRAEFIK_ARTIFACT}" -C /usr/local/bin traefik && \
    # end of logic to verify SHA256
    chmod +x /usr/local/bin/traefik && \
    rm -f /tmp/*

COPY rootfs /
RUN chmod a+x /etc/cont-init.d/traefik.sh \
    && chmod a+x /etc/services.d/nginx/run \
    && chmod a+x /etc/services.d/traefik/run    

LABEL \
    io.hass.name="Treafik TEST for ${BUILD_ARCH}" \
    io.hass.description="Home Assistant Unofficial Add-on: ${BUILD_ARCH} Traefik TEST image" \
    maintainer="BoomAM" \
    org.opencontainers.image.title="Traefik for TEST ${BUILD_ARCH}" \
    org.opencontainers.image.description="Home Assistant Unofficial Add-on: ${BUILD_ARCH} Traefik TEST image" \
    org.opencontainers.image.vendor="BoomAM" \
    org.opencontainers.image.authors="BoomAM" \
    org.opencontainers.image.url="https://github.com/boomam/home-assistant-addons" \
    org.opencontainers.image.source="https://github.com/boomam/home-assistant-addons" \
    org.opencontainers.image.documentation="https://github.com/boomam/home-assistant-addons/blob/master/traefik-test/README.md" \
    org.opencontainers.image.created=${BUILD_DATE} \
    org.opencontainers.image.revision=${BUILD_REF} \
    org.opencontainers.image.version=${BUILD_VERSION}
