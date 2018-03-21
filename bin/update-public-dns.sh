#!/bin/sh
echo "update-public-dns: start with arg $1"

if [ -e /home/ubuntu/.candela/config ]; then
	. /home/ubuntu/.candela/config
fi
env

if [ -z $DOMAIN_NAME ] || [ -z $ZONE_ID_PUBLIC ]; then
	echo "update-public-dns: ERROR - no domain name or zone id found !"
	exit 0
fi

if [ -z $1 ]; then
	echo "update-local-dns: ERROR - no arg !"
	exit 0
fi

HOST_NAME=$1
echo "update-public-dns: updating $HOST_NAME at $DOMAIN_NAME ..."

CLI53="/home/ubuntu/bin/cli53"
TTL=300

PUBLIC_IPV4=$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4)
RECORD="$HOST_NAME $TTL A ${PUBLIC_IPV4}"
CMD="$CLI53 rrcreate --replace $ZONE_ID_PUBLIC '"$RECORD"'"
eval $CMD

echo "update-public-dns: done for $HOSTNAME.$DOMAIN_NAME"

