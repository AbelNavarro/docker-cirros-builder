FROM ubuntu:14.04

MAINTAINER Abel Navarro <abel.navarro@gmail.com>

RUN apt-get update && apt-get install -y git

RUN git clone git://git.launchpad.net/~cirros-dev/cirros

