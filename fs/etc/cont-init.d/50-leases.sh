#!/usr/bin/with-contenv ash

if [ ! -f "/leases/dhcp.leases" ]; then
  touch "/leases/dhcp.leases"
fi

chown -R "$PUID:$PGID" "/leases"
chown -R "$PUID:$PGID" "/var/lib/dhcp"