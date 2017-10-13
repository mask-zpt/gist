#!/bin/bash

. /etc/profile

cp /etc/ssh/sshd_config ~/.ssh/
cd /tmp
tar -czvf ssh.tgz ~/.ssh/* /etc/ssh/sshd_config ~/ssh_new.sh ~/ssh_old.sh 

scp ssh.tgz root@100:/tmp
scp ssh.tgz root@101:/tmp
scp ssh.tgz root@102:/tmp
scp ssh.tgz root@103:/tmp
