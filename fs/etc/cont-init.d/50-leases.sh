#!/usr/bin/with-contenv ash

if [ ! -f "/leases/dhcpd.leases" ]; then
  touch "/leases/dhcpd.leases"
fi

chown -R "$PUID:$PGID" "/leases"
chown -R "$PUID:$PGID" "/var/lib/dhcp"