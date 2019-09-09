FROM alpine:3.10
MAINTAINER Thomas Coats <thomas.coats@github.com>

ADD . /install/
RUN /install/install.sh
CMD ["/sbin/initsh"]
