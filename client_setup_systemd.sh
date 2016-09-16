#!/bin/bash
set -e
if [ "$#" -lt 2 ]; then
  echo "Usage: sudo ./client_setup_systemd.sh ssh_key logstash_host"
  exit 1
fi
apt-get install -y autossh
cp $1 /home/ubuntu/tunnelsshkey

echo -e "[Unit]\n"\
"Description=autossh tunnel\n"\
"After=network.target\n"\
"[Service]\n"\
"User=root\n"\
"ExecStart=/usr/bin/autossh -M 0 -N -L 5045:localhost:5044 -L 15044:localhost:15044 -o \"ServerAliveInterval 30\" -o \"ServerAliveCountMax 2\" -o \"StrictHostKeyChecking=no\" -o \"BatchMode=yes\" -i /home/ubuntu/tunnelsshkey tunnel@$2\n"\
"Restart=on-failure\n"\
"RestartSec=30\n"\
"[Install]\n"\
"WantedBy=multi-user.target\n" > /etc/systemd/system/loggingtunnel.service

service loggingtunnel start
