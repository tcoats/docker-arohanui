# Aroha

Runit, Syslog-ng and Consul with an init script.

This docker is a base docker for some of the metocean web-stack.

## /sbin/initsh

The docker is started using /sbin/initsh as the master process (PID 1), it does does the following:

* checks the /startup folder for any startup .sh scripts.
* starts runsvdir, runit then starts the services in the docker.
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

example:

This example makes docker output the message 'meh lets not run' and exits with 35 when you try to run metocean/aroha.

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

## Syslog-ng

Processes / services started in this docker are expected to output logs to stdout. Syslog-ng then pipes these back to initsh (PID 1) which then pipes this back to the host running the docker.

## Consul

MetOcean uses the consul for service discovery, failover etc... check consul.io for more details.

If you would like consul to not run at startup you can do the following:

create /tmp/startup/stop_consul.sh with:
``` bash
echo 'removing consul service'
rm -rf /etc/service/consul
```
run docker with the /startup folder mounted.
``` bash
docker run -v /tmp/startup:/startup metocean/aroha
```
