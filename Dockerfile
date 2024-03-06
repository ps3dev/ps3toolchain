FROM ubuntu:24.04
LABEL maintainer="miigotu@gmail.com"

ENV PS3DEV /usr/local/ps3dev
ENV PSL1GHT ${PS3DEV}
ENV PATH ${PATH}:${PS3DEV}/bin:${PS3DEV}/ppu/bin:${PS3DEV}/spu/bin
ENV PKG_CONFIG_PATH $PKG_CONFIG_PATH:$PS3DEV/portlibs/ppu/lib/package

ENV DEBIAN_FRONTEND=noninteractive

RUN \
  apt -y update && \
  apt --no-install-recommends install -y autoconf automake bison build-essential bzip2 \
  ca-certificates flex gettext-base git libelf-dev libgmp3-dev libncurses5-dev libssl-dev \
  libtool libtool-bin make patch pkg-config python-dev-is-python3 texinfo wget xz-utils zlib1g-dev && \
  apt -y clean autoclean autoremove && \
  rm -rf /var/lib/{apt,dpkg,cache,log}

RUN mkdir /build
WORKDIR /build
COPY . /build

# Fixes certificate errors with letsencrypt in ARMv7
RUN echo "\nca_certificate=/etc/ssl/certs/ca-certificates.crt" | tee -a /etc/wgetrc
RUN /build/toolchain.sh

