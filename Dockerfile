FROM gliderlabs/alpine:3.3
MAINTAINER Thomas Coats <thomas@metocean.co.nz>

ENV CONSUL_VERSION=0.6.3

ADD . /install/
RUN /install/install.sh
CMD ["/sbin/initsh"]