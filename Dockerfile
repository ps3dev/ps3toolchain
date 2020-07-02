FROM ubuntu:latest
LABEL maintainer="miigotu@gmail.com"

ENV PS3DEV /usr/local/ps3dev
ENV PSL1GHT /usr/local/ps3dev
ENV PATH $PATH:/usr/local/ps3dev/bin:/usr/local/ps3dev/ppu/bin:/usr/local/ps3dev/spu/bin
ENV PS3TOOLCHAIN /ps3_toolchain
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get -yq update && \
    apt-get -y install autoconf bison build-essential flex git libelf-dev pkg-config python-dev texinfo wget zlib1g-dev && \
    apt-get -y clean autoclean autoremove && find /var/cache/apt/archives /var/lib/apt/lists /var/lib/dpkg /var/log -not -name lock -type f -delete

RUN mkdir $PS3TOOLCHAIN $PS3DEV
WORKDIR $PS3TOOLCHAIN
COPY . .
VOLUME $PS3DEV
RUN $PS3TOOLCHAIN/toolchain.sh
RUN rm -rf $PS3TOOLCHAIN
CMD /bin/bash

