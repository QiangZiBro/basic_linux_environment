#!/bin/sh

#------------------------------------------------------------------------------
# Configure the service. This script runs in docker container
#------------------------------------------------------------------------------
start=$1
/usr/sbin/privoxy --no-daemon /etc/privoxy/config &
if [ "$start" = "daemon" ]; then
    sslocal -c etc/ss/ss.json  &
else
    sslocal -c etc/ss/ss.json
fi
