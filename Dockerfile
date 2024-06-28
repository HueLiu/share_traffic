FROM ubuntu:22.04

RUN apt-get update && apt-get upgrade -y
RUN apt-get install sudo vim python-is-python3 supervisor unzip tar curl wget netcat -y
RUN apt-get install ca-certificates dos2unix -y
RUN apt-get install xvfb procps -y
RUN apt-get update && apt-get install nodejs -y
RUN apt-get install npm -y
RUN rm -rf /sbin/initctl && ln -s /sbin/initctl.distrib /sbin/initctl

# BitPing
RUN curl https://bitping.com/install.sh | bash

# CloudCollab
# docker exec <container id> cat /root/.config/CloudCollab/deviceid | od -A n -v -t x1 | tr -d  ' '
# RUN mkdir /opt/cloudcollab
# RUN wget -O cloudcollab https://update.cloudcollab.uk/versions/CloudCollab-0.0.3-x64
# RUN mv ./cloudcollab /opt/cloudcollab/cloudcollab

# EarnApp
RUN mkdir /opt/earnapp
COPY ./sh/earnapp/ /opt/earnapp/
RUN dos2unix /opt/earnapp/*
RUN cp /opt/earnapp/install.sh /usr/bin/install
RUN echo -e "#\!/bin/bash \n echo \"$(lsb_release -a)\"" > /usr/bin/lsb_release
RUN echo -e "#\!/bin/bash \n echo \"$(hostnamectl)\"" > /usr/bin/hostnamectl
RUN chmod a+x /usr/bin/install /usr/bin/hostnamectl /usr/bin/lsb_release
RUN bash /opt/earnapp/setup.sh

# EarnFM
RUN mkdir /opt/earnfm
COPY ./sh/earnfm/ /opt/earnfm/

# GagaNode
RUN wget -P /opt https://assets.coreservice.io/public/package/65/gaganode_pro/0.0.300/gaganode_pro-0_0_300.tar.gz
RUN cd /opt && tar -zxf gaganode_pro-0_0_300.tar.gz && rm -f gaganode_pro-0_0_300.tar.gz
RUN mv /opt/gaganode-linux-386 /opt/gaganode
COPY ./sh/gaganode/ /opt/gaganode/

# Honeygain
RUN mkdir /opt/honeygain
COPY ./sh/honeygain/libhg.so* /usr/lib/
ENV LD_LIBRARY_PATH=/usr/lib
COPY ./sh/honeygain/ /opt/honeygain/

# IproyalPawns
RUN mkdir /opt/iproyalpawns
RUN wget -O pawns-cli https://cdn.pawns.app/download/cli/latest/linux_x86_64/pawns-cli
RUN mv ./pawns-cli /opt/iproyalpawns/pawns-cli

# Meson
RUN wget -P /opt 'https://staticassets.meson.network/public/meson_cdn/v3.1.20/meson_cdn-linux-amd64.tar.gz'
RUN mkdir /etc/init
RUN cd /opt \
    && tar -zxf meson_cdn-linux-amd64.tar.gz \
    && rm -f meson_cdn-linux-amd64.tar.gz \
    && mv /opt/meson_cdn-linux-amd64 /opt/meson
COPY ./sh/meson/ /opt/meson/

# Packetstream
RUN mkdir /usr/local/bin/linux_386
RUN mkdir /usr/local/bin/linux_amd64
RUN mkdir /usr/local/bin/linux_arm
RUN mkdir /usr/local/bin/linux_arm64
COPY ./sh/packetstream/linux_386 /usr/local/bin/linux_386
COPY ./sh/packetstream/linux_amd64 /usr/local/bin/linux_amd64
COPY ./sh/packetstream/linux_arm /usr/local/bin/linux_arm
COPY ./sh/packetstream/linux_arm64 /usr/local/bin/linux_arm64
COPY ./sh/packetstream/pslauncher /usr/local/bin
ENV PS_IS_DOCKER=true

# Peer2profit
# RUN mkdir /opt/peer2profit
# COPY ./sh/peer2profit/ /opt/peer2profit
# RUN cd /opt/peer2profit && apt-get install -y ./peer2profit_0.48_amd64.deb

# Proxylite
RUN mkdir /opt/proxylite
COPY ./sh/proxylite/ /opt/proxylite
RUN chmod +x /opt/proxylite/proxylite.sh

# Proxyrack
RUN mkdir /opt/proxyrack
COPY ./sh/proxyrack/ /opt/proxyrack

# Speedshare
RUN mkdir /opt/speedshare
COPY ./sh/speedshare/ /opt/speedshare

# SpideNetwork
RUN mkdir /opt/spidenetwork
COPY ./sh/spidenetwork/ /opt/spidenetwork

RUN chmod -R 777 /opt

RUN rm -rf /var/lib/apt/lists/*

# 拷贝脚本
COPY ./supervisor/ /etc/supervisor/conf.d/
RUN mkdir /home/logs/
RUN chmod -R 777 /home/

# Define default command.
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/supervisord.conf"]
