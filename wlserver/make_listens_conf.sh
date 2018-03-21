#!/bin/sh

LOCAL_IPV4=$(curl -s http://169.254.169.254/latest/meta-data/local-ipv4)

echo "listen $LOCAL_IPV4:6379 ssl;" > listen_redis.conf
echo "listen $LOCAL_IPV4:2022;" > listen_2022.conf
echo "listen $LOCAL_IPV4:2122;" > listen_2122.conf

