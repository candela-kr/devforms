#!/bin/sh
echo "start_rtstate: start."

/home/ubuntu/bin/start_server.sh rtstate
/home/ubuntu/bin/update-local-dns.sh rtstate

echo "start_rtstate: done."
