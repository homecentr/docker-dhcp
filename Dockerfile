FROM homecentr/base:3.2.0-alpine

ENV DHCP_ARGS=""

RUN apk add --no-cache \
        dhcp=4.4.2-r1 \
        libcap=2.27-r0 && \
    rm /etc/dhcp/dhcpd.conf.example && \
    mkdir /leases && \
    chmod 0777 /leases && \
    mkdir /config && \
    setcap 'cap_net_raw+ep' /usr/sbin/dhcpd && \
    setcap 'cap_net_bind_service=+ep' /usr/sbin/dhcpd && \
    deluser dhcp 

COPY ./fs/ /

EXPOSE 67/udp

VOLUME /leases
VOLUME /config