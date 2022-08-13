#!/bin/bash
set -e

in_error() {
    in_log ERROR "$@" >&2
    exit 1
}
    
file=/var/www/html/include/ost-config.php

if [[  ! -f /var/www/html/include/ost-config.php ]]; then
    echo "Config file not found - exiting"
    echo "Did you mount your config file as a volume with docker-compose?"
    echo "Please checkout the instructions - https://hub.docker.com/r/comprofix/invoiceninja"
    exit 0
fi
chmod 644 "${file}"
echo "osTicket ready"
exec "$@"