FROM debian:stretch-slim

ARG DEBIAN_FRONTEND=noninteractive

WORKDIR /tmp/dsistudio
COPY [".", "src/"]
RUN apt-get update -qq \
    && apt-get install -yq --no-install-recommends \
        bzip2 \
        ca-certificates \
        curl \
        dbus \
        freeglut3-dev \
        g++ \
        gcc \
        git \
        libboost-all-dev \
        libgl1-mesa-dev \
        libglu1-mesa-dev \
        libqt5opengl5-dev \
        make \
        mesa-utils \
        openssh-client \
        qt5-qmake \
        qt5-default \
        unzip \
        zlib1g-dev \
    && git clone -b master https://github.com/frankyeh/TIPL.git src/tipl \
    && mkdir build \
    && cd build \
    && qmake ../src \
    && make \
    && mkdir -p /opt/dsi_studio \
    && mv dsi_studio /opt/dsi_studio/ \
    && ln -s /opt/dsi_studio/dsi_studio /usr/local/bin/dsi_studio \
    && cd /opt/dsi_studio \
    && curl -LO https://dl.dropbox.com/s/rq5khgmoyiye0op/dsi_studio_other_files.zip \
    && unzip dsi_studio_other_files.zip \
    && rm -f dsi_studio_other_files.zip \
    && apt-get clean \
    && apt-get remove -yq --purge curl g++ gcc git make unzip \
    && apt-get autoremove -yq \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

WORKDIR /work
ENTRYPOINT ["/opt/dsi_studio/dsi_studio"]
