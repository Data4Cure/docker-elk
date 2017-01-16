#!/bin/bash
set -e
if [ "$#" -lt 2 ]; then
  echo "Usage: sudo ./client_setup.sh ssh_key logstash_host"
  exit 1
fi
apt-get install -y autossh
cp $1 /home/ubuntu/tunnelsshkey

echo -e "description \"autossh tunnel\"\n"\
"start on (local-filesystems and net-device-up IFACE=eth0)\n"\
"stop on runlevel [016]\n"\
"respawn\n"\
"respawn limit 5 60\n"\
"exec autossh -M 0 -N -L 5045:localhost:5044 -L 172.18.0.1:5045:localhost:5044 -L 15044:localhost:15044 -L 172.18.0.1:15044:localhost:15044 -o \"ServerAliveInterval=30\""\
" -o \"ServerAliveCountMax=2\" -o \"StrictHostKeyChecking=no\" -o \"BatchMode=yes\""\
" -i /home/ubuntu/tunnelsshkey tunnel@$2" > /etc/init/loggingtunnel.conf

start loggingtunnel
