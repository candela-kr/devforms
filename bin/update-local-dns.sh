#!/bin/sh

echo "update-local-dns: start with arg $1"

if [ -e /home/ubuntu/.candela/config ]; then
	. /home/ubuntu/.candela/config
fi
env

if [ -z $DOMAIN_NAME ] || [ -z $ZONE_ID_PRIVATE ]; then
	echo "update-local-dns: ERROR - no domain name or zone id found !"
	exit 0
fi

if [ -z $1 ]; then
	echo "update-local-dns: ERROR - no arg !"
	exit 0
fi

HOST_NAME=$1
echo "update-local-dns: updating $HOST_NAME at $DOMAIN_NAME ..."

CLI53="/home/ubuntu/bin/cli53"
TTL=300
LOCAL_IPV4=$(curl -s http://169.254.169.254/latest/meta-data/local-ipv4)
RECORD="$HOST_NAME $TTL A ${LOCAL_IPV4}"
CMD="$CLI53 rrcreate --replace $ZONE_ID_PRIVATE '"$RECORD"'"
eval $CMD

echo "update-local-dns: done for $HOSTNAME.$DOMAIN_NAME"

