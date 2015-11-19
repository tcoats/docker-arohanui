# Aroha

Runit, Syslog-ng and Consul with an init script.

This docker is a base docker for some of the metocean web-stack.

## /sbin/initsh

The docker is started using /sbin/initsh as the master process (PID 1), it does does the following:

* checks /startup folder for any startup .sh scripts.
* starts runit, runit then starts the services in the docker.
* when the docker is shutdown initsh signals all ruint services to stop, then waits 2 seconds, then shuts down.
* handles zombie processes.

## runit

runit is used for starting / stopping and logging of services.

To make runit start a service you either link or copy a sh script called "run" into:

/etc/services/[service name]/run

check [/consul/etc/service/consul/run] in this repo as an example run file.

http://smarden.org/runit/

## startup folder

"/sbin/initsh" script checks for the existance of a directory '/startup' and will execute any scripts that end with ".sh".
Notes:
* the startup scripts run before runit.
* if any script exits with a none zero code the docker will exit with the same code and not start runit.

example 1:

This example stops docker the docker from starting up.

create /tmp/startup/kill_docker.sh with:
``` bash
echo 'meh lets not run'
exit 35
```
run docker with the /startup folder mounted.
``` bash
docker run -v /tmp/startup:/startup metocean/aroha
```
output will be
``` bash
meh lets not run
INIT ERROR: script /startup/test.sh exited with code 35
```

example 2:

in this example we will stop consul from starting.

create /tmp/startup/stop_consul.sh with:
``` bash
echo 'removing consul service'
rm -rf /etc/service/consul
```
run docker with the /startup folder mounted.
``` bash
docker run -v /tmp/startup:/startup metocean/aroha
```

## Syslog-ng

## Consul
