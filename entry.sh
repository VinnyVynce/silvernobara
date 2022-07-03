#!/bin/sh

echo "*/5 * * * * echo /ostree/build.sh" >> /etc/c/root
crond -l 2 -f > /dev/stdout 2> /dev/stderr &
