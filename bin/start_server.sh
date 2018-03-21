#!/bin/sh

echo "start_server: start with arg = $1"

MYHOME=/home/ubuntu

cd $MYHOME
if [ -e .candela/config ]; then
	. .candela/config
fi

if [ -n $1 ]; then
	SERVER=$1
fi

if [ -z $SERVER ]; then
	echo "start_server: String server : ERROR - no server specified ! "
	env
	exit 0
fi

SERVER_HOME=$MYHOME/$SERVER
echo "start_server: server home at $SERVER_HOME ..."

if [ ! -e $SEVER_HOME ]; then
	echo "start_server: ERROR - no server home ($SERVER_HOME) found! "
	exit 0
fi

cd $SERVER_HOME
if [ -e /tmp/version_$SERVER ]; then 
	echo "start_server: updating ..."
	git pull
	echo "start_server: updating done"
fi
pm2 startOrReload process.json

cd $MYHOME
echo "start_server: pm2 list ..."
pm2 list

echo "start_server: done for $SERVER"
