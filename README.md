# Shadowsocks Privoxy in Docker

Forked from [bluebu/shadowsocks-privoxy](bluebu/shadowsocks-privoxy) . Specified for shadowsocks & privoxy service in docker container. Can be easily used for command line proxy and python development. You can run the program in anywhere there is docker installed.

## Prequisity

- Docker

- SS config file in [./rootfs/etc/ss/](./rootfs/etc/ss/) :

```json
# ss.json
{
  ...
}
```



## Usage

**Install**

```bash
https://github.com/QiangZiBro/basic_linux_environment.git
cd basic_linux_environment
# build docker image
./bootstrap.sh
```



**Start service**

```bash
# service
./bin/spd_service [start|stop|exec]
```



**Command proxy in local machine:**

- Usage
```bash
spd start
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
