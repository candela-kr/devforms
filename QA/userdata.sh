#!/bin/sh

if [ ! -e /home/ubuntu/.candela ]; then
	mkdir /home/ubuntu/.candela
fi

curl -s https://s3.ap-northeast-2.amazonaws.com/config.candela.kr/config_candela_qa >> /home/ubuntu/.candela/config

curl -s https://s3.ap-northeast-2.amazonaws.com/tools.candela.kr/update.sh > /tmp/update.sh
if [ -e /tmp/update.sh ]; then
	chmod +x /tmp/update.sh
	/tmp/update.sh
fi

curl -s https://s3.ap-northeast-2.amazonaws.com/tools.candela.kr/rc.local.qa > /etc/rc.local
chmod +x /etc/rc.local
/etc/rc.local

