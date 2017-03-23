# docker-cirros-builder
Docker files to build custom Cirros image

# Development cheatsheet
docker build -t docker-cirros-builder .
docker cp <containerId>:/root/cirros/output/x86_64/disk.img ./cirros-thttpd.img

# Notes
* The container takes about 4GB of disk space
