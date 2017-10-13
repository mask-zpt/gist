#!/bin/bash

. /etc/profile


VERSION=' Version 0.0.1, 2017年10月12日, Copyright (c) 2017 kelvinblood';

usage () {
    echo '没有帮助';
}



if [ "$#" -eq 0 ]; then
    usage
    exit 0
fi

case $1 in
    -h|h|help )
        usage
        exit 0;
        ;;
    -v|v|version )
        echo $VERSION;
        exit 0;
        ;;
esac

if [ "$EUID" -ne 0 ]; then
    echo "必需以root身份运行，请使用sudo等命令"
    exit 1;
fi

USERNAME=$1

userdel $USERNAME
rm -rf /home/$USERNAME
