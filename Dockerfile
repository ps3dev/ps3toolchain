FROM ubuntu:latest
LABEL maintainer="miigotu@gmail.com"

ENV PS3DEV /usr/local/ps3dev
ENV PSL1GHT /usr/local/ps3dev
ENV PATH $PATH:/usr/local/ps3dev/bin:/usr/local/ps3dev/ppu/bin:/usr/local/ps3dev/spu/bin

ENV DEBIAN_FRONTEND=noninteractive

RUN \
  apt-get -y update && \
  apt-get -y install \
  autoconf bison build-essential flex git libelf-dev \
  libgmp3-dev libncurses5-dev libssl-dev libtool-bin pkg-config python-dev \
  texinfo wget zlib1g-dev && \
  apt-get -y clean autoclean autoremove && \
  rm -rf /var/lib/{apt,dpkg,cache,log}/

RUN mkdir /ps3_toolchain
WORKDIR /ps3_toolchain
COPY . /ps3_toolchain
VOLUME $PS3DEV /ps3_toolchain
RUN /ps3_toolchain/toolchain.sh
CMD /bin/bash

