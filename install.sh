#!/bin/sh
set -e

apk update
apk upgrade

apk add nodejs zeromq syslog-ng runit
cp -R /install/syslog-ng/* /
cp -R /install/initsh/* /
cp -R /install/bashalias/* /

# Clean up
rm -rf /install
rm -rf /tmp/*
rm -rf /var/cache/apk/*
