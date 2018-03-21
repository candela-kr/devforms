#!/bin/sh

CONFIG_MODE="dev"
SERVER="rtserver"
CONFIG_FILE="config_${SERVER}_${CONFIG_MODE}"
RC_FILE="rc.local.${SERVER}_${CONFIG_MODE}"

if [ ! -e /home/ubuntu/.candela ]; then
	mkdir /home/ubuntu/.candela
fi

curl -s https://s3.ap-northeast-2.amazonaws.com/config.candela.kr/${CONFIG_FILE} >> /home/ubuntu/.candela/config

#curl -s https://s3.ap-northeast-2.amazonaws.com/tools.candela.kr/update.sh > /tmp/update.sh
#if [ -e /tmp/update.sh ]; then
#	chmod +x /tmp/update.sh
#	/tmp/update.sh
#fi

curl -s https://s3.ap-northeast-2.amazonaws.com/tools.candela.kr/${RC_FILE} > /etc/rc.local
chmod +x /etc/rc.local
/etc/rc.local

