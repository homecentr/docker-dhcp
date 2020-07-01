[![Project status](https://badgen.net/badge/project%20status/stable%20%26%20actively%20maintaned?color=green)](https://github.com/homecentr/docker-dhcp/graphs/commit-activity) [![](https://badgen.net/github/label-issues/homecentr/docker-dhcp/bug?label=open%20bugs&color=green)](https://github.com/homecentr/docker-dhcp/labels/bug) [![](https://badgen.net/github/release/homecentr/docker-dhcp)](https://hub.docker.com/repository/docker/homecentr/dhcp)
[![](https://badgen.net/docker/pulls/homecentr/dhcp)](https://hub.docker.com/repository/docker/homecentr/dhcp) 
[![](https://badgen.net/docker/size/homecentr/dhcp)](https://hub.docker.com/repository/docker/homecentr/dhcp)

![CI/CD on master](https://github.com/homecentr/docker-dhcp/workflows/CI/CD%20on%20master/badge.svg)
![Regular Docker image vulnerability scan](https://github.com/homecentr/docker-dhcp/workflows/Regular%20Docker%20image%20vulnerability%20scan/badge.svg)


# HomeCentr - ISC DHCP Server


## Usage

```yml
version: "3.7"
services:
  dhcp:
    image: homecentr/dhcp
  network: host
  volumes:
    - ./example:/config
```

## Environment variables

| Name | Default value | Description |
|------|---------------|-------------|
| PUID | 7077 | UID of the user dhcp should be running as. |
| PGID | 7077 | GID of the user dhcp should be running as. |

## Exposed ports

| Port | Protocol | Description |
|------|------|-------------|
| 67 | UDP | DHCP Server |

:warning: Due to the nature of the DHCP protocol which is highly dependent on broadcast, exposing the container via a bridge network will not work as explained below. Because of this, the container should be exposed via drivers which allow the container to expose the port directly (host, macvlan, ipvlan).

> Docker daemon will not pass the broadcast packets to the container because the container internally has an IP specific to the bridge network (e.g. 172.16.10.1) but the broadcast packet will be sent with the IP of your host machine (e.g. 192.168.2.50). The bridge will therefore decide the broadcast packet was not meant for the container and will not forward it.

## Volumes

| Container path | Description |
|------------|---------------|
| /config | Configuration directory which must contain the `dhcpd.conf` file. See the official [documentation](https://kb.isc.org/docs/aa-00502) on how to configure the DHCP server. |
| /leases | This is where the DHCP server records which IP addresses have been leased to individual clients. The location must be writable by the PUID/PGID. |

## Security
The container is regularly scanned for vulnerabilities and updated. Further info can be found in the [Security tab](https://github.com/homecentr/docker-dhcp/security).

### Container user
The container supports privilege drop. Even though the container starts as root, it will use the permissions only to perform the initial set up. The dhcp process runs as UID/GID provided in the PUID and PGID environment variables.

:warning: Do not change the container user directly using the `user` Docker compose property or using the `--user` argument. This would break the privilege drop logic.