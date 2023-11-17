#syntax=docker/dockerfile:1

#- [ Extractor Stage ] ---------------------------------------------------------
FROM ubuntu:22.04 AS extractor

# Install dependencies
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    p7zip-rar \
    && rm -rf /var/lib/apt/lists/*

# Package sources:
# Mirror 1: Web Archive  https://web.archive.org/web/20150919174246/http://psx-scene.com/forums/f153/%5Bwindows-linux%5D-fmcb-1-9x-installer-ps3-memory-card-adaptor-132919/
# Mirror 2: PS2-Home     https://www.ps2-home.com/forum/viewtopic.php?t=297#p755
ARG PACKAGE_URL="https://web.archive.org/web/20180613053213if_/http://de-ge.so/ps2/ps3mca-tool-fmcb-1.94.rar"
ARG PACKAGE_MD5="0099bfb4e8ed31a968d764834f64cfc3"

# Download ps3mca package and extract
WORKDIR /tmp
RUN curl -fsSL ${PACKAGE_URL} -o $(basename ${PACKAGE_URL}) && \
    echo "${PACKAGE_MD5} $(basename ${PACKAGE_URL})" > $(basename "${PACKAGE_URL}.md5") && \
    md5sum -c $(basename "${PACKAGE_URL}.md5") && \
    7z e $(basename ${PACKAGE_URL}) -ops3mca -y && \
    chmod +x ps3mca/ps3mca-tool

#- [ Runner Stage ] ------------------------------------------------------------
FROM ubuntu:22.04

# Install dependencies
RUN dpkg --add-architecture i386 && \
    apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    libusb-0.1-4:i386 \
    && rm -rf /var/lib/apt/lists/*

# Copy extracted binary from extractor stage
COPY --from=extractor /tmp/ps3mca/ps3mca-tool /usr/local/bin/

# Workdir setup
WORKDIR /root/mca