#!/bin/bash
set -e
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR
echo -e "Match User tunnel\n"\
        "  AllowAgentForwarding no\n"\
        "  ForceCommand echo 'This account can only be used for tunnel creation'"\
        >> /etc/ssh/sshd_config
service ssh restart
useradd -m tunnel
ssh-keygen -t rsa -b 4096 -C "nobody@data4cure.com" -f tunnelsshkey -N ""
mkdir -p /home/tunnel/.ssh/ 
cat tunnelsshkey.pub >> /home/tunnel/.ssh/authorized_keys
chown tunnel:tunnel /home/tunnel/.ssh/authorized_keys
echo "Use tunnelsshkey on client servers to build ssh tunnels"
