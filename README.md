![mDNS enabled minio/minio](https://raw.githubusercontent.com/hausgold/docker-minio/master/docs/assets/project.png)

[![Continuous Integration](https://github.com/hausgold/docker-minio/actions/workflows/package.yml/badge.svg?branch=master)](https://github.com/hausgold/docker-minio/actions/workflows/package.yml)
[![Source Code](https://img.shields.io/badge/source-on%20github-blue.svg)](https://github.com/hausgold/docker-minio)
[![Docker Image](https://img.shields.io/badge/image-on%20docker%20hub-blue.svg)](https://hub.docker.com/r/hausgold/minio/)

This Docker images provides the [minio/minio](https://hub.docker.com/r/minio/minio) image as base
with the mDNS/ZeroConf stack on top. So you can enjoy [minio](https://min.io/) while
it is accessible by default as *minio.local*. (HTTP API Port 80 -> Port 9000,
Web console Port 9090)

The root users credentials are `minioadmin` / `minioadmin`. You can change this
by the `MINIO_ROOT_USER` / `MINIO_ROOT_PASSWORD` environment variables.

When the `BUCKET_NAME` environment variable is not-empty, we automatically
create a new bucket with that name. Furthermore we allow anonymous downloads
for this bucket. This is handy for testing an application with a local-S3
(compatible) service.

- [Requirements](#requirements)
- [Getting starting](#getting-starting)
- [docker-compose usage example](#docker-compose-usage-example)
- [Host configs](#host-configs)
- [Configure a different mDNS hostname](#configure-a-different-mdns-hostname)
- [Other top level domains](#other-top-level-domains)
- [Further reading](#further-reading)

## Requirements

* Host enabled Avahi daemon
* Host enabled mDNS NSS lookup

## Getting starting

You just need to run it like that, to get a working minio:

```bash
$ docker run --rm hausgold/minio
```

Both ports port 9000 (API) is untouched, but can also be accessed
via mDNS at port 80. The web console is available on port 9090.

## docker-compose usage example

```yaml
services:
  minio:
    image: hausgold/minio
    environment:
      # Mind the .local suffix
      MDNS_HOSTNAME: minio.test.local
```

## Host configs

Install the nss-mdns package, enable and start the avahi-daemon.service. Then,
edit the file /etc/nsswitch.conf and change the hosts line like this:

```bash
hosts: ... mdns4_minimal [NOTFOUND=return] resolve [!UNAVAIL=return] dns ...
```

## Configure a different mDNS hostname

The magic environment variable is *MDNS_HOSTNAME*. Just pass it like that to
your docker run command:

```bash
$ docker run --rm -e MDNS_HOSTNAME=something.else.local hausgold/minio
```

This will result in *something.else.local*.

You can also configure multiple aliases (CNAME's) for your container by
passing the *MDNS_CNAMES* environment variable. It will register all the comma
separated domains as aliases for the container, next to the regular mDNS
hostname.

```bash
$ docker run --rm \
  -e MDNS_HOSTNAME=something.else.local \
  -e MDNS_CNAMES=nothing.else.local,special.local \
  hausgold/minio
```

This will result in *something.else.local*, *nothing.else.local* and
*special.local*.

## Other top level domains

By default *.local* is the default mDNS top level domain. This images does not
force you to use it. But if you do not use the default *.local* top level
domain, you need to [configure your host avahi][custom_mdns] to accept it.

## Further reading

* Docker/mDNS demo: https://github.com/Jack12816/docker-mdns
* Archlinux howto: https://wiki.archlinux.org/index.php/avahi
* Ubuntu/Debian howto: https://wiki.ubuntuusers.de/Avahi/

[custom_mdns]: https://wiki.archlinux.org/index.php/avahi#Configuring_mDNS_for_custom_TLD
