#!/bin/sh
cd /ostree

mkdir -p $CACHE

if [ ! -d $REPO/objects ]; then
    ostree --repo=$REPO init --mode=archive-z2
fi

rpm-ostree compose tree --unified-core --cachedir=$CACHE --repo=$REPO fedora-silvernobara.yaml
ostree summary --repo=$REPO --update

cp -rf /tmp/repo/* /repo/
