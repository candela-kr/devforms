#!/bin/sh

CONFIG_FILE="/home/ubuntu/.candela/config"

echo "start_rtserver: start."
/home/ubuntu/bin/start_server.sh rtserver

if [ -e ${CONFIG_FILE} ]; then
	. ${CONFIG_FILE}
fi

if [ -n "QXSERVER" ]; then
	echo "start_rtserver: starting qxserver ..."
	/home/ubuntu/bin/start_server.sh qxserver
	echo "start_rtserver: starting qxserver done."
fi
	
echo "start_rtserver: done."
