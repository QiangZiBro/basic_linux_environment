#!/bin/bash

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
