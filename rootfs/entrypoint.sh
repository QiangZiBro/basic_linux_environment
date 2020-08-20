#!/bin/sh

#------------------------------------------------------------------------------
# Configure the service. This script runs in docker container
#------------------------------------------------------------------------------
start=$1
/usr/sbin/privoxy --no-daemon /etc/privoxy/config &
echo '
Usage:
PROXY_PORT=8008
export http_proxy=127.0.0.1:$PROXY_PORT
export https_proxy=127.0.0.1:$PROXY_PORT
curl google.com
git config --global https.proxy https://127.0.0.1:$PROXY_PORT
'
if [ "$start" = "daemon" ]; then
    sslocal -c etc/ss/ss.json  &
else
    sslocal -c etc/ss/ss.json
fi
