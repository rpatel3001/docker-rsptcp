FROM ghcr.io/sdr-enthusiasts/docker-baseimage:soapyrtlsdr

ENV SOAPY="" \
    RATE=2100000 \
    FREQ=133000000 \
    PPM=0 \
    GAIN=agc \
    TCP_PORT=7374

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# hadolint ignore=DL3008,SC2086,DL4006,SC2039
RUN set -x && \
    TEMP_PACKAGES=() && \
    KEPT_PACKAGES=() && \
    # packages needed to install
    TEMP_PACKAGES+=(git) && \
    # packages needed for my sanity
    KEPT_PACKAGES+=(nano) && \
    # packages needed to build
    TEMP_PACKAGES+=(build-essential) && \
    TEMP_PACKAGES+=(cmake) && \
    TEMP_PACKAGES+=(pkg-config) && \
    # install packages
    apt-get update && \
    apt-get install -y --no-install-recommends \
        "${KEPT_PACKAGES[@]}" \
        "${TEMP_PACKAGES[@]}" && \
    # Deploy rtlmuxer
    git clone https://github.com/rpatel3001/rtlmuxer.git /src/rtlmuxer && \
    pushd /src/rtlmuxer && \
    make && \
    cp rtlmuxer /usr/local/bin && \
    # Clean up
    apt-get remove -y "${TEMP_PACKAGES[@]}" && \
    apt-get autoremove -y && \
    rm -rf /src/* /tmp/* /var/lib/apt/lists/*

COPY rootfs/ /
