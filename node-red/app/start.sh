#!/bin/bash

export DBUS_SYSTEM_BUS_ADDRESS=unix:path=/host/run/dbus/system_bus_socket

# rpiplc hw-config 
# ExecStartPre equivalent: Wait for /dev/ttySC* to exist
while [ ! -c /dev/ttySC* ]; do 
    sleep 1
done
sleep 1

# ExecStart equivalent: Run the hw-config command
/usr/local/bin/hw-config


# Make sure ssh known hosts file is present
if ! test -f /data/known_hosts;
    then
        touch /data/known_hosts;
fi

ssh-keyscan -t rsa github.com >> /data/known_hosts

# Make the default flows available in the user library
mkdir -p /data/node-red/user/lib/flows || true
cp /usr/src/app/flows/* /data/node-red/user/lib/flows/


# Start node-red
node-red --settings /usr/src/app/settings.js
