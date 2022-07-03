#!/bin/sh
cd /ostree

mkdir -p /tmp/cache

if [ ! -d /tmp/repo/objects ]; then
    /usr/bin/ostree --repo=/tmp/repo init --mode=archive-z2
fi

/usr/bin/rpm-ostree compose tree --unified-core --cachedir=/tmp/cache --repo=/tmp/repo fedora-silvernobara.yaml
/usr/bin/ostree summary --repo=/tmp/repo --update

/bin/cp -rf /tmp/repo/* /repo
