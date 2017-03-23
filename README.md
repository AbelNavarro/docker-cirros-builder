# docker-cirros-builder
Docker files to build custom Cirros image

# Development cheatsheet

## Build the Docker image
```
docker build -t docker-cirros-builder .
```

## Get compiled Cirros image
```
docker run --privileged -i -v /tmp/cirros_img/:/root/cirros/output/x86_64/images/ -t docker-cirros-builder
mv /tmp/cirros_img/disk.img /tmp/cirros_img/cirros-thttpd.img
```

# Notes
* The container takes about 4GB of disk space
