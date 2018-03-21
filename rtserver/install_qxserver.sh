#!/bin/bash

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

git clone https://git-codecommit.ap-northeast-2.amazonaws.com/v1/repos/qxserver
cd qxserver
npm i

echo "installing done."
