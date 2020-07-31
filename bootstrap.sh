#/bin/bash
#--------------------------------------------------
# Build and Initiation script
#--------------------------------------------------

#COMMAND="source $( realpath  $(dirname $0)/bin/spd.sh)"
#
#if ! grep -Fxq "$COMMAND" ~/.zshrc
#then
#    # not found
#    echo $COMMAND >> ~/.zshrc
#fi

# config
#if test "$(uname)" = "Darwin"
#then
#	# Mac installation branch
#    echo You are mac
#	
#elif test "$(expr substr $(uname -s) 1 5)" = "Linux"
#then
#	# Linux installation branch
#    echo You are linux
#    # sudo cp ./ss.service /etc/systemd/system/
#	
#fi

if [ "$1" = "build" ]; then
    docker build -t ss:common .
elif [ "$1" = "rebuild" ];then
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
    ./bootstrap.sh exec
fi
