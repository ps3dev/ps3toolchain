FROM debian:12-slim AS base
LABEL maintainer="miigotu@gmail.com"

ENV PS3DEV=/usr/local/ps3dev \
    PSL1GHT=/usr/local/ps3dev \
    DEBIAN_FRONTEND=noninteractive \
    PYTHON_VERSION=3.10 \
    PYENV_ROOT=/root/.pyenv \
    PIP_ROOT_USER_ACTION=ignore \
    PKG_CONFIG_PATH=/usr/local/ps3dev/portlibs/ppu/lib/pkgconfig
ENV PATH="${PYENV_ROOT}/shims:${PYENV_ROOT}/bin:${PATH}:${PS3DEV}/bin:${PS3DEV}/ppu/bin:${PS3DEV}/spu/bin:${PS3DEV}/portlibs/ppu/bin"

RUN apt update -y && \
    apt --no-install-recommends install -y autoconf automake bison build-essential bzip2 \
    ca-certificates cmake flex gettext-base git libelf-dev libgmp3-dev libncurses5-dev libssl-dev \
    libtool libtool-bin make patch pkg-config texinfo wget xz-utils zlib1g-dev && \
    # Fixes certificate errors with letsencrypt in ARMv7
    echo 'ca_certificate=/etc/ssl/certs/ca-certificates.crt' >> /etc/wgetrc && \
    # Install dependencies specific for amd64 architecture
    if [ "$(uname -m)" = "x86_64" ]; then apt install -y nvidia-cg-toolkit ; fi && \
    # pyenv
    apt --no-install-recommends install -y zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev \
    llvm libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev curl git && \
    echo 'cacert=/etc/ssl/certs/ca-certificates.crt' >> ~/.curlrc && \
    git config --global http.sslverify 'false' && \
    curl https://pyenv.run | bash && \
    pyenv update && pyenv install $PYTHON_VERSION && pyenv global $PYTHON_VERSION && pyenv rehash && \
    pip install pycrypto && \
    apt -y clean autoclean autoremove

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
