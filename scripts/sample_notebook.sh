#!/bin/bash

if [ ! -d /data/demo ]; then
    cp -a /usr/local/samples /data/demo
fi

sudo /etc/init.d/ssh start
nohup /usr/local/scripts/runh2o 2>&1 | tee /tmp/h2odeepwater.log &
exec /usr/local/bin/nimbix_notebook "$@"
