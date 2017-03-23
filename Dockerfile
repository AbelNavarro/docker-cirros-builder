FROM ubuntu:14.04

LABEL maintainer "Abel Navarro <abel.navarro@gmail.com>"

ENV ARCH x86_64
ENV BR_VER 2015.05

RUN apt-get update && apt-get install -y git wget

RUN ( cd /root && git clone git://git.launchpad.net/~cirros-dev/cirros )

RUN ( cd /root/cirros && ./bin/system-setup )

RUN mkdir -p /root/download
RUN ln -snf /root/download /root/cirros/download
RUN ( cd /root/download && wget http://buildroot.uclibc.org/downloads/buildroot-$BR_VER.tar.gz )
RUN ( cd /root/cirros && tar -xvf /root/download/buildroot-$BR_VER.tar.gz )
RUN ln -snf /root/cirros/buildroot-$BR_VER /root/cirros/buildroot

RUN ( cd /root/cirros/buildroot && QUILT_PATCHES=/root/cirros/patches-buildroot quilt push -a )

RUN apt-get install -y python
RUN ( cd /root/cirros && make ARCH=$ARCH br-source )

RUN ( cd /root/cirros && make ARCH=$ARCH OUT_D=/root/cirros/output/$ARCH )

ENV KVER 3.19.0-20.20~14.04.1
RUN ( cd /root/cirros && ./bin/grab-kernels "$KVER" )

ENV GVER 2.02~beta2-36ubuntu8
WORKDIR /root/cirros
RUN apt-get install -y grub-common
RUN ./bin/grab-grub-efi "$GVER"

WORKDIR /root/cirros
CMD ./bin/bundle -v --arch=$ARCH output/$ARCH/rootfs.tar download/kernel-$ARCH.deb download/grub-efi-$ARCH.tar.gz output/$ARCH/images
