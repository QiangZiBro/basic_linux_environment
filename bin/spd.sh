#!/bin/bash
spd () { 

	if [ "$1" = "start" ];then 
		export http_proxy="127.0.0.1:8118" 
		export https_proxy="127.0.0.1:8118" 
		git config --global https.proxy https://127.0.0.1:8118 

	elif [ "$1" = "stop" ];then 
		export http_proxy="" 
		export https_proxy="" 

	elif [ "$1" = "reload" ];then 
        echo "Not impl yet :)"
	else 
		echo "Wrong parameter!Usage: spd [start|stop]" 
	fi 
} 
#spd
