#!/bin/bash
echo "Setting token"
cd /opt/gaganode
./gaganode config set --token=$GAGANODE_TOKEN
./gaganode
