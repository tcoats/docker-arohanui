#!/bin/sh
set -e

apk update
apk upgrade

# Install Consul
apk add go git gcc musl-dev make bash wget unzip zip
export GOPATH=/tmp/go
go get github.com/mitchellh/gox
export PATH=$PATH:/tmp/go/bin
go get github.com/hashicorp/consul
cd /tmp/go/src/github.com/hashicorp/consul
git checkout v$CONSUL_VERSION
make
mv bin/consul /usr/bin
mkdir /consul-ui
cd /consul-ui
wget -O ui.zip http://releases.hashicorp.com/consul/${CONSUL_VERSION}/consul_${CONSUL_VERSION}_web_ui.zip
unzip ui.zip
rm ui.zip
apk del go git gcc musl-dev make bash wget unzip zip
cp -R /install/consul/* /

# Install node.js syslog-ng zeromq initsh bashalias
apk add syslog-ng
cp -R /install/syslog-ng/* /
cp -R /install/initsh/* /
cp -R /install/bashalias/* /

# Install Runit
testing_repo="http://dl-4.alpinelinux.org/alpine/edge/testing"
echo "$testing_repo" >> /etc/apk/repositories
apk update
apk add runit
grep -v "$testing_repo" /etc/apk/repositories > /etc/apk/repositories.tmp
mv /etc/apk/repositories.tmp /etc/apk/repositories

# Clean up
rm -rf /install
rm -rf /tmp/*
rm -rf /var/cache/apk/*
