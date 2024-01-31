#!/bin/bash
echo "Setting token"
cd /opt/gaganode
timeout 3 ./apphub
./apps/gaganode/gaganode config set --token=$GAGANODE_TOKEN
./apphub
