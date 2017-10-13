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
PASSWDCH="$USERNAME:Qweewq"


if [ -e "/home/$USERNAME" ]; then
    echo '该账户home目录已存在'
    exit 0
fi

useradd $USERNAME -d /home/$USERNAME -G wheel;
echo $PASSWDCH | chpasswd

if [ -e "/home/$USERNAME/.ssh" ]; then
    rm -rf "/home/$USERNAME/.ssh"
fi


mkdir /home/$USERNAME/.ssh
cd /home/$USERNAME/.ssh

sudo ssh-keygen -b 1024 -t rsa -C $USERNAME -f "/home/$USERNAME/.ssh/$USERNAME"
touch authorized_keys
touch config

cat $USERNAME >> authorized_keys

cat >> config << EOF
# add by weikelu
Host    100
  HostName        172.10.1.100
  Port            22
  User            $USERNAME
  IdentityFile    /home/$USERNAME/.ssh/$USERNAME
Host    101
  HostName        172.10.1.101
  Port            22
  User            $USERNAME
  IdentityFile    /home/$USERNAME/.ssh/$USERNAME
Host    102
  HostName        172.10.1.102
  Port            22
  User            $USERNAME
  IdentityFile    /home/$USERNAME/.ssh/$USERNAME
Host    103
  HostName        172.10.1.103
  Port            22
  User            $USERNAME
  IdentityFile    /home/$USERNAME/.ssh/$USERNAME
EOF

###########################################################

ssh 101 "useradd $USERNAME -d /home/$USERNAME -G wheel"
ssh 101 "echo $PASSWDCH | chpasswd"

cd /home/$USERNAME/.ssh

ssh 101 "mkdir /home/$USERNAME/.ssh"
scp config 101:"/home/$USERNAME/.ssh/config"
scp authorized_keys 101:"/home/$USERNAME/.ssh/authorized_keys"
ssh 101 "chown -R $USERNAME:$USERNAME /home/$USERNAME/.ssh"

###########################################################

ssh 102 "useradd $USERNAME -d /home/$USERNAME -G wheel"
ssh 102 "echo $PASSWDCH | chpasswd"

cd /home/$USERNAME/.ssh

ssh 102 "mkdir /home/$USERNAME/.ssh"
scp config 102:"/home/$USERNAME/.ssh/config"
scp authorized_keys 102:"/home/$USERNAME/.ssh/authorized_keys"
ssh 102 "chown -R $USERNAME:$USERNAME /home/$USERNAME/.ssh"

###########################################################

ssh 103 "useradd $USERNAME -d /home/$USERNAME -G wheel"
ssh 103 "echo $PASSWDCH | chpasswd"

cd /home/$USERNAME/.ssh

ssh 103 "mkdir /home/$USERNAME/.ssh"
scp config 103:"/home/$USERNAME/.ssh/config"
scp authorized_keys 103:"/home/$USERNAME/.ssh/authorized_keys"
ssh 103 "chown -R $USERNAME:$USERNAME /home/$USERNAME/.ssh"

###########################################################

chmod 400 authorized_keys
chown -R $USERNAME:$USERNAME /home/$USERNAME/.ssh
