# Host compiler is GCC 16.2.0 from the official image (Debian Trixie).
FROM gcc:16.2.0-trixie AS base
LABEL maintainer="miigotu@gmail.com"

ENV PS3DEV=/usr/local/ps3dev \
    PSL1GHT=/usr/local/ps3dev \
    DEBIAN_FRONTEND=noninteractive \
    PYTHON_VERSION=3.10 \
    PYENV_ROOT=/root/.pyenv \
    PIP_ROOT_USER_ACTION=ignore \
    PKG_CONFIG_PATH=/usr/local/ps3dev/portlibs/ppu/lib/pkgconfig \
    CC=gcc \
    CXX=g++
ENV PATH="${PYENV_ROOT}/shims:${PYENV_ROOT}/bin:${PATH}:${PS3DEV}/bin:${PS3DEV}/ppu/bin:${PS3DEV}/spu/bin:${PS3DEV}/portlibs/ppu/bin"

RUN apt-get update -y && \
    apt-get --no-install-recommends install -y autoconf automake bison bzip2 \
    ca-certificates cmake flex gettext-base git libelf-dev libgmp-dev libncurses-dev libssl-dev \
    libtool libtool-bin make patch pkg-config texinfo wget xz-utils zlib1g-dev && \
    # Fixes certificate errors with letsencrypt in ARMv7
    echo 'ca_certificate=/etc/ssl/certs/ca-certificates.crt' >> /etc/wgetrc && \
    # nvidia-cg-toolkit is non-free and amd64-only
    if [ "$(uname -m)" = "x86_64" ]; then \
      if [ -f /etc/apt/sources.list.d/debian.sources ]; then \
        sed -i 's/Components: main$/Components: main contrib non-free non-free-firmware/' /etc/apt/sources.list.d/debian.sources ; \
      fi && \
      apt-get update -y && apt-get install -y nvidia-cg-toolkit ; \
    fi && \
    # pyenv
    apt-get --no-install-recommends install -y zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev \
    llvm libncurses-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev curl git && \
    echo 'cacert=/etc/ssl/certs/ca-certificates.crt' >> ~/.curlrc && \
    git config --global http.sslverify 'false' && \
    curl https://pyenv.run | bash && \
    pyenv update && pyenv install $PYTHON_VERSION && pyenv global $PYTHON_VERSION && pyenv rehash && \
    pip install pycrypto && \
    apt-get -y clean autoclean autoremove && \
    rm -rf /var/lib/apt/lists/*

FROM base AS builder
RUN mkdir /build
WORKDIR /build
COPY . /build
RUN mkdir -p "${PS3DEV}" && /build/toolchain.sh

FROM base AS runtime
COPY --from=builder ${PS3DEV} ${PS3DEV}

# How to build and run a multi platform image
# Tested platforms: linux/amd64 or linux/arm64
# DOCKER_DEFAULT_PLATFORM=linux/arm64 docker build . -t ps3dev
# DOCKER_DEFAULT_PLATFORM=linux/arm64 docker run -it -v `pwd`:/build -w /build ps3dev
