FROM gliderlabs/alpine:3.2
MAINTAINER Thomas Coats <thomas@metocean.co.nz>

ENV CONSUL_VERSION=0.5.2 GOMAXPROCS=2

ADD . /install/
RUN /install/install.sh
CMD ["/sbin/initsh"]