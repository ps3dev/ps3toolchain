FROM ubuntu:24.04
LABEL maintainer="miigotu@gmail.com"

# Set the default shell to Bash
SHELL ["/bin/bash", "-c"]

ENV PS3DEV /usr/local/ps3dev
ENV PSL1GHT ${PS3DEV}
ENV PATH ${PATH}:${PS3DEV}/bin:${PS3DEV}/ppu/bin:${PS3DEV}/spu/bin:${PS3DEV}/portlibs/ppu/bin
ENV PKG_CONFIG_PATH $PS3DEV/portlibs/ppu/lib/pkgconfig

ENV DEBIAN_FRONTEND=noninteractive
# last python version with diskutils module support
ENV PYTHON_VERSION=3.11.8
ENV PYENV_ROOT="$HOME/.pyenv"
ENV PATH="$PYENV_ROOT/shims:$PYENV_ROOT/bin:$PATH"

RUN \
  apt -y update && \
  apt --no-install-recommends install -y autoconf automake bison build-essential bzip2 \
  ca-certificates flex gettext-base git libelf-dev libgmp3-dev libncurses5-dev libssl-dev \
  libtool libtool-bin make patch pkg-config texinfo wget xz-utils zlib1g-dev && \
  # pyenv 
  apt --no-install-recommends install -y zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev \
  llvm libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev curl && \
  curl https://pyenv.run | bash && \
  pyenv update && \
  pyenv install $PYTHON_VERSION && \
  pyenv global $PYTHON_VERSION && \
  pyenv rehash && \
  # pyenv
  apt -y clean autoclean autoremove
  
RUN mkdir /build
WORKDIR /build
COPY . /build

# Fixes certificate errors with letsencrypt in ARMv7
RUN echo "ca_certificate=/etc/ssl/certs/ca-certificates.crt" >> /etc/wgetrc
RUN /build/toolchain.sh

