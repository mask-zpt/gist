#!/bin/bash

. /etc/profile

cd /tmp

if [ -e '/tmp/root' ]; then
	rm -rf /tmp/root
fi

tar -xzvf ssh.tgz

cd root
if [ -e '/root/.ssh' ]; then
	rm -rf /root/.ssh
fi

mv .ssh ~/
mv ~/.ssh/sshd_config /etc/ssh/sshd_config

systemctl restart sshd
