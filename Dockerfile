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
        curl git procps tmux zsh
#    rm -rf /var/lib/apt/lists/*

#Config file
WORKDIR /home/$USER/rootfs
ADD rootfs /home/$USER/rootfs
COPY ./Qdotfiles /home/$USER/.Qdotfiles

USER $USER

# install ohmyzsh
RUN ./entrypoint.sh daemon &&\
    sleep 2 &&\
    export https_proxy="127.0.0.1:8118" && export http_proxy="127.0.0.1:8118" &&\
    # Your command that need proxy
    wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -qO - | zsh && \
    cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc && \
    echo 'export LANG=en_US.utf8' >> ~/.zshrc && sudo -p password chsh $USER -s $(which zsh) 

# install neovim 
RUN sudo -p password apt install --no-install-recommends -y neovim &&\
    ./entrypoint.sh daemon &&\
    sleep 2 &&\
    export https_proxy="127.0.0.1:8118" && export http_proxy="127.0.0.1:8118" &&\

    sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

RUN ./entrypoint.sh daemon &&\
    sleep 2 &&\
    export https_proxy="127.0.0.1:8118" && export http_proxy="127.0.0.1:8118" &&\
    sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim' 

RUN ./entrypoint.sh daemon &&\
    sleep 2 &&\
    export https_proxy="127.0.0.1:8118" && export http_proxy="127.0.0.1:8118" &&\

    cd ~/.Qdotfiles && ./scripts/bootstrap.sh &&\
    nvim +PlugInstall +qall

ENV spd="/home/$USER/rootfs/entrypoint.sh daemon && sleep 2 && export https_proxy=127.0.0.1:8118 && export http_proxy=127.0.0.1:8118"
RUN $spd && curl google.com
ENTRYPOINT [ "/usr/bin/zsh" ]
#CMD ["./entrypoint.sh"]
