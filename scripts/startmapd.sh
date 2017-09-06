#!/bin/bash

export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/lib/jvm/java-8-openjdk-ppc64el/jre/lib/ppc64le/server
export DISPLAY=:1

X :1 &
/usr/bin/nvidia-xconfig --use-display-device=none --enable-all-gpus --preserve-busid
cd /home/mapd-ee-3.1.1-20170628-45a6fa8-Linux-ppc64le-render-glx
./startmapd 2>&1 | tee /tmp/mapd.log
