#!/usr/bin/with-contenv ash

adduser nonroot dhcp

if [ ! -f "/leases/dhcp.leases" ]; then
  touch "/leases/dhcp.leases"
fi

# TODO: Try to add $PUID to dhcp group - does it grant any permissions?

#chown -R "root:root" "/leases/dhcp.leases"
chown -R "$PUID:$PGID" "/leases"
chown -R "$PUID:$PGID" "/var/lib/dhcp"