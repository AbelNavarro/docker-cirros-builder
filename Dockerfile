FROM ubuntu:14.04

LABEL maintainer "Abel Navarro <abel.navarro@gmail.com>"

ENV ARCH x86_64
ENV BR_VER 2015.05

RUN apt-get update && apt-get install -y git wget python grub-common

WORKDIR /root
RUN git clone git://git.launchpad.net/~cirros-dev/cirros

WORKDIR /root/cirros
RUN ./bin/system-setup

RUN mkdir download
WORKDIR download

RUN wget http://buildroot.uclibc.org/downloads/buildroot-$BR_VER.tar.gz
WORKDIR /root/cirros
RUN tar -xvf /root/cirros/download/buildroot-$BR_VER.tar.gz
RUN ln -snf /root/cirros/buildroot-$BR_VER /root/cirros/buildroot

WORKDIR buildroot
RUN QUILT_PATCHES=/root/cirros/patches-buildroot quilt push -a

# Get buildroot source
WORKDIR /root/cirros
RUN make ARCH=$ARCH br-source

# Patch buildroot config to add the desired packages
RUN sed -i '/# BR2_PACKAGE_THTTPD/c\BR2_PACKAGE_THTTPD=y' conf/buildroot-$ARCH.config
RUN sed -i '/# BR2_PACKAGE_TCPDUMP/c\BR2_PACKAGE_TCPDUMP=y' conf/buildroot-$ARCH.config

# Build buildroot
RUN make ARCH=$ARCH OUT_D=/root/cirros/output/$ARCH

ENV KVER 3.19.0-20.20~14.04.1
RUN ./bin/grab-kernels "$KVER"

ENV GVER 2.02~beta2-36ubuntu8
RUN ./bin/grab-grub-efi "$GVER"

CMD ./bin/bundle -v --arch=$ARCH output/$ARCH/rootfs.tar download/kernel-$ARCH.deb download/grub-efi-$ARCH.tar.gz output/$ARCH/images
