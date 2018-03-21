#!/bin/sh

echo "update-dns: start with arg $1"

if [ -z $1 ]; then
	echo "update-dns: ERROR - no arg for host name !"
	exit 0
fi

/home/ubuntu/bin/update-local-dns.sh $1
/home/ubuntu/bin/update-public-dns.sh $1

echo "update-dns: done for $1"

