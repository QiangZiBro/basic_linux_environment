# Shadowsocks Privoxy in Docker

Forked from [bluebu/shadowsocks-privoxy](bluebu/shadowsocks-privoxy) . Specified for shadowsocks & privoxy service in docker container. Can be easily used for command line proxy and python development. You can run the program in anywhere there is docker installed.

## Prequisity

- Docker

## Pre-config and Docker building
```bash
# build docker image
./bootstrap.sh
```

You should add ss config file in [./rootfs/etc/ss/](./rootfs/etc/ss/) :

```json
# ss.json
{
  ...
}
```



## Usage

```bash
https://github.com/QiangZiBro/basic_linux_environment.git
cd basic_linux_environment

# start
./bin/spd_service start

# exec into doceker after start
./bin/spd_service exec

# stop
./bin/spd_service stop
```



**Command proxy in local machine:**

- Setup
```bash
# each http request will use proxy port:8118
export https_proxy="127.0.0.1:8118"
export http_proxy="127.0.0.1:8118"
```
- Now, have a try:
```bash
# In your local machine
curl google.com
# If blow shows up, then success!

#<HTML><HEAD><meta http-equiv="content-type" content="text/html;charset=utf-8">
#<TITLE>301 Moved</TITLE></HEAD><BODY>
#<H1>301 Moved</H1>
#The document has moved
#<A HREF="http://www.google.com/">here</A>.
#</BODY></HTML>
```