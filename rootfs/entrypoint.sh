#!/bin/sh

#------------------------------------------------------------------------------
# Configure the service. This script runs in docker container
#------------------------------------------------------------------------------
env sslocal -b 127.0.0.1 -l 7070 -s $SERVER_ADDR -p $SERVER_PORT -k $PASSWORD -m ${METHOD} -d start

env /usr/sbin/privoxy --no-daemon etc/privoxy/config
