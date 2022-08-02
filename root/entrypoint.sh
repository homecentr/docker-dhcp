#!/usr/bin/env bash

# Ensure the leases file exists
if [ ! -f "/leases/dhcpd.leases" ]; then
  touch /leases/dhcpd.leases
  chmod 0777 /leases/dhcpd.leases
fi

<<<<<<< Updated upstream
whoami
ls -l /leases

=======
>>>>>>> Stashed changes
exec "$@"