#!/bin/bash

cd /usr/local/lib/python2.7/dist-packages/h2o

patch --dry-run < /usr/local/scripts/h2o.py.patch
if [ $? -eq 0 ]; then
	patch < /usr/local/scripts/h2o.py.patch
fi
