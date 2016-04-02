FROM gliderlabs/alpine:3.3
MAINTAINER Thomas Coats <thomas@metocean.co.nz>

ADD . /install/
RUN /install/install.sh
CMD ["/sbin/initsh"]