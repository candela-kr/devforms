#!/bin/bash

# set sshd to listen non-loopback interface when port forwarding
sudo echo "GatewayPorts yes" >> /etc/ssh/sshd_config

# install redis server
sudo apt-get -y install redis-server

# set redis.conf
sudo cp /tmp/redis.conf /etc/redis/

# install nginx
sudo apt-get -y install  nginx

# set nginx conf
sudo cp /home/ubuntu/nginx/nginx.conf /etc/nginx/
sudo rm /etc/nginx/conf.d/default 
sudo rm /etc/nginx/sites-enabled/default 
# default will include confs in /home/ubuntu/nginx, no need to copy 
sudo ln -s /home/ubuntu/nginx/default /etc/nginx/sites-enabled/
# ngnix.conf will include in http context
sudo ln -s /home/ubuntu/nginx/appdata_upstream.conf  /etc/nginx/conf.d/

if [ ! -e /usr/local/bin/pm2 ]; then
	sudo npm install -g pm2
fi

cd /home/ubuntu

if [ ! -e .gitconfig ]; then
	aws s3 cp s3://tools.candela.kr/gitconfig .gitconfig
fi

if [ ! -e .git-credentials ]; then
	aws s3 cp s3://tools.candela.kr/gitcredentials .git-credentials
fi

git clone https://git-codecommit.ap-northeast-2.amazonaws.com/v1/repos/wlserver
cd wlserver
npm i


