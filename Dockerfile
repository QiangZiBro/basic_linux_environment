#------------------------------------------------------------------------------
# Python Environment
#------------------------------------------------------------------------------
FROM continuumio/miniconda3


#------------------------------------------------------------------------------
# Linux Environment
#------------------------------------------------------------------------------
COPY ./rootfs/etc/apt/sources.list /etc/apt/sources.list
RUN apt-get update --fix-missing -qqy && apt-get update  -qqy
ENV USER=qiangzibro
RUN export uid=1000 gid=1000 pswd=password &&\
    apt-get install -y --no-install-recommends sudo privoxy && \
    apt-get clean && \
    groupadd -g $gid $USER && \
    useradd -g $USER -G sudo -m -s /bin/bash $USER && \
    # -m : create home dir if not exists
    echo "$USER:$pswd" | chpasswd && \
    mkdir -p /home/$USER && \
    mkdir -p /etc/sudoers.d && \
    echo "$USER ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/$USER && \
    chmod 0440 /etc/sudoers.d/$USER && \
    chown ${uid}:${gid} -R /home/$USER 
    


#------------------------------------------------------------------------------
# Change to china source, install privoxy and shadowsocks and fix ssl bug
#------------------------------------------------------------------------------
COPY .pip /root/.pip
RUN python3 -m pip install shadowsocks &&\
    sed -i "s|cleanup|reset|g"  /opt/conda/lib/python3.7/site-packages/shadowsocks/crypto/openssl.py


#------------------------------------------------------------------------------
# Expose ports, so you can use the exposed port when build:
# -p your_local_port:8118
# export https_proxy="127.0.0.1:your_local_port"  &&  export http_proxy="127.0.0.1:your_local_port"
#------------------------------------------------------------------------------
EXPOSE 8118


#------------------------------------------------------------------------------
#  Install softwares, below are things that maybe frequently modified
#------------------------------------------------------------------------------
RUN apt-get install -y --no-install-recommends \
        curl git procps                       
#    rm -rf /var/lib/apt/lists/*

USER $USER
WORKDIR /home/$USER/rootfs
ADD rootfs /home/$USER/rootfs

# Example 1: Use command proxy either in container or docker file,
# remember to sleep for a while, because the configuration can't start that fast
RUN echo "Testing for command in docker:\n" &&\
    ./entrypoint.sh daemon &&\
    sleep 2 &&\
    export https_proxy="127.0.0.1:8118" && export http_proxy="127.0.0.1:8118" &&\
    # Your command that need proxy
    curl google.com 

# Example 2: Use image as a service
CMD ["./entrypoint.sh"]
