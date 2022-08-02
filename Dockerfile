FROM bitnami/minideb:bullseye

ARG USER_UID=1000
ARG USER_GID=1000

COPY ./root/ /

RUN install_packages isc-dhcp-server libcap2-bin && \
    addgroup --gid ${USER_GID} nonroot && \
    adduser --uid ${USER_UID} --gid ${USER_GID} --no-create-home --disabled-password --gecos "" nonroot && \
    mkdir /leases && \
    chmod 0777 /leases && \
    mkdir /config && \
    chmod a+x /entrypoint.sh && \
    chown ${USER_UID}:${USER_GID} /var/lib/dhcp && \
    setcap 'CAP_NET_BIND_SERVICE,CAP_NET_RAW=+ep' /usr/sbin/dhcpd

USER ${USER_UID}:${USER_GID}

EXPOSE 67/udp

VOLUME /leases
VOLUME /config

ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/usr/sbin/dhcpd", "-4", "-f", "-cf", "/config/dhcpd.conf", "-lf", "/leases/dhcpd.leases", "--no-pid" ]