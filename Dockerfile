FROM debian:stretch-slim

RUN apt-get update && apt-get install -y \
  make \
  python3 \
  python3-serial \
  wget \
  tar \
  git \
  libncurses5-dev \
&& rm -rf /var/lib/apt/lists/*

RUN ln -s /usr/bin/python3.5 /usr/bin/python

WORKDIR /opt

ARG ARM_GCC_URL=https://developer.arm.com/-/media/Files/downloads/gnu-rm/9-2020q2/gcc-arm-none-eabi-9-2020-q2-update-x86_64-linux.tar.bz2

RUN wget $ARM_GCC_URL -O temp.tar.bz2 \
&& mkdir sdk \
&& tar -xjf temp.tar.bz2 -C sdk --strip-components 1 \
&& rm -rf temp.tar.bz2

ENV PATH="/opt/sdk/bin:${PATH}"

RUN mkdir /opt/stm32loader/ && \
    cd /opt/stm32loader/ && \
    wget https://raw.githubusercontent.com/jsnyder/stm32loader/master/stm32loader.py && \
    chmod +x /opt/stm32loader/stm32loader.py && \
    ln -s /opt/stm32loader/stm32loader.py /usr/local/bin/stm32loader

ARG UID=1000
ARG GID=1000
RUN groupadd -g $GID -o mightyteam
RUN useradd -m -u $UID -g $GID -o -s /bin/bash mightyteam

RUN usermod -a -G dialout mightyteam
RUN usermod -a -G plugdev mightyteam

USER mightyteam

WORKDIR /home/mightyteam
