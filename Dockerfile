#------------------------------------------------------------------------------
# Python Environment
#------------------------------------------------------------------------------
FROM continuumio/miniconda3


#------------------------------------------------------------------------------
# Linux Environment
#------------------------------------------------------------------------------
COPY ./rootfs/etc/apt/sources.list /etc/apt/sources.list
RUN apt-get update --fix-missing 
ENV USER=qiangzibro
RUN export uid=1000 gid=1000 pswd=password &&\
    apt-get install -y --no-install-recommends sudo privoxy && \
    apt-get clean && \
    groupadd -g $gid $USER && \
    useradd -g $USER -G sudo -m -s /bin/bash $USER && \
    echo "$USER:$pswd" | chpasswd && \
    mkdir -p /home/$USER && \
    mkdir -p /etc/sudoers.d && \
    echo "$USER ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/$USER && \
    chmod 0440 /etc/sudoers.d/$USER && \
    chown ${uid}:${gid} -R /home/$USER && \
    rm -rf /var/lib/apt/lists/*


#------------------------------------------------------------------------------
# Change to china source and fix ssl bug
#------------------------------------------------------------------------------
COPY .pip /root/.pip
RUN python3 -m pip install shadowsocks &&\
    sed -i "s|cleanup|reset|g"  /opt/conda/lib/python3.7/site-packages/shadowsocks/crypto/openssl.py


#------------------------------------------------------------------------------
# These environments could use -e command
# Example
#   docker run -it -e SERVER_ADDR=8.8.8.8. ss:v1 
#------------------------------------------------------------------------------
ENV SERVER_ADDR= \
    SERVER_PORT=17377 \
    METHOD=aes-128-ctr\
    TIMEOUT=300 \
    PASSWORD=UBsv9z


ADD rootfs /home/$USER/rootfs

#------------------------------------------------------------------------------
# Expose ports, so you can use the exposed port when build:
# -p your_local_port:8118
# export https_proxy="127.0.0.1:your_local_port"  &&  export http_proxy="127.0.0.1:your_local_port"
#------------------------------------------------------------------------------
EXPOSE 8118
WORKDIR /home/$USER/rootfs
CMD ["./entrypoint.sh"]
