FROM ubuntu:20.04
LABEL maintainer="miigotu@gmail.com"

ENV PS3DEV /usr/local/ps3dev
ENV PSL1GHT ${PS3DEV}
ENV PATH ${PATH}:${PS3DEV}/bin:${PS3DEV}/ppu/bin:${PS3DEV}/spu/bin

ENV DEBIAN_FRONTEND=noninteractive

RUN \
  apt-get -y update && \
  apt-get -y install \
  autoconf bison build-essential ca-certificates flex git libelf-dev\
  libgmp3-dev libncurses5-dev libssl-dev libtool-bin pkg-config python-dev \
  texinfo wget zlib1g-dev && \
  apt-get -y clean autoclean autoremove && \
  rm -rf /var/lib/{apt,dpkg,cache,log}/

RUN mkdir /build
WORKDIR /build
COPY . /build

# Fixes certificate errors with letsencrypt in ARMv7
RUN echo "\nca_certificate=/etc/ssl/certs/ca-certificates.crt" | tee -a /etc/wgetrc
RUN /build/toolchain.sh

