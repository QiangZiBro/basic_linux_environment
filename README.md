# Shadowsocks Privoxy in Docker

Forked from [bluebu/shadowsocks-privoxy](bluebu/shadowsocks-privoxy) . Specified for shadowsocks & privoxy service in docker container. Can be easily used for command line proxy and python development. You can run the program in anywhere there is docker installed.

## Prequisity

- Docker

## Pre-config and Docker building
```bash
./bootstrap.sh
```

## Usage

**Start the container**

```bash
./bin/spd_service [start|stop]
```

You should modify ss config in [./bin/spd_service](./bin/spd_service) by:

```
docker run -d  -p <your_local_port>:8118 \
  -e SERVER_ADDR=your_ss_server_ip\
  -e SERVER_PORT=your_ss_server_port\
  -e PASSWORD=your_pass_word\
  -e METHOD=your_method\
  ss:v1
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