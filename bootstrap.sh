#/bin/bash

TITLE="SHADOWSOCKERS PRIVOXY DOCKER"
MY_COMMAND='
#<=================================== 
spd () { 
	if [ "$1" = "start" ] 
	then 
		export http_proxy="127.0.0.1:8118" 
		export https_proxy="127.0.0.1:8118" 
		echo http_proxy=$http_proxy 
		echo https_proxy=$https_proxy 
		git config --global https.proxy https://127.0.0.1:8118 
	else 
		if [ "$1" = "stop" ] 
		then 
			export http_proxy="" 
			export https_proxy="" 
			echo http_proxy=$http_proxy 
			echo https_proxy=$https_proxy 
		else 
			echo "Wrong parameter!Usage: spd [start|stop]" 
		fi 
	fi 
} 
#===================================> 
'

if ! grep -Fxq "$TITLE" ~/.zshrc
then
    # not found
    echo $MY_COMMAND >> ~/.zshrc
fi

# config
if test "$(uname)" = "Darwin"
then
	# Mac installation branch
    echo You are mac
	
elif test "$(expr substr $(uname -s) 1 5)" = "Linux"
then
	# Linux installation branch
    echo You are linux
    sudo cp ./ss.service /etc/systemd/system/
	
fi

docker build -t ss:v1 .
