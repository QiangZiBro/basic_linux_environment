#!/bin/sh

#------------------------------------------------------------------------------
# Configure the service. This script runs in docker container
#------------------------------------------------------------------------------
start=$1
/usr/sbin/privoxy --no-daemon /etc/privoxy/config &
# env /usr/sbin/privoxy  etc/privoxy/config
# env sslocal -b 127.0.0.1 -l 1080 -s ${SERVER_ADDR} -p ${SERVER_PORT} -k ${PASSWORD} -m ${METHOD} --log-file /home/${USER}/ss.log
if [ "$start" = "daemon" ]; then
    sslocal -c etc/ss/ss.json  &
else
    sslocal -c etc/ss/ss.json
fi
