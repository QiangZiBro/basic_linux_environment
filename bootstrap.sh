#/bin/bash
#--------------------------------------------------
# Build and Initiation helper script
#--------------------------------------------------

if [ "$1" = "build" ]; then
    ./bin/spd_service stop 
    docker build -t ss:common .

elif [ "$1" = "all" ]; then
    docker build -t ss:common .
    ./bin/spd_service stop
    ./bin/spd_service start
    ./bin/spd_service exec zsh

elif [ "$1" = "exec" ]; then
    ./bin/spd_service start
    ./bin/spd_service exec zsh
elif [ "$1" = "reexec" ]; then
    ./bin/spd_service stop
    ./bootstrap.sh exec zsh

elif [ "$1" = "start" ]; then
    ./bin/spd_service start
elif [ "$1" = "stop" ]; then
    ./bin/spd_service stop

elif [ "$1" = "clean" ]; then
    docker stop $(docker ps -a | grep "Exited" | awk '{print $1 }') #停止容器
    docker rm $(docker ps -a | grep "Exited" | awk '{print $1 }') #删除容器
    docker rmi $(docker images | grep "none" | awk '{print $3}') #删除镜像

elif [ "$1" = "update" ]; then
    root=`pwd`
    cd ~/.Qdotfiles/
    git pull origin master
    git add -A && git commit -m 'update'
    git push origin HEAD

    cd "$root"
    git pull origin master
    git submodule foreach --recursive git pull origin master
    git add -A && git commit -m 'update '
    git push origin HEAD
    ssh l2 "/bin/bash /home/qiangzibro/myscripts/update_environments.sh"
fi
