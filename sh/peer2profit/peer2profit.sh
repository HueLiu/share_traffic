#!/bin/bash

P2P_CONFIG="/root/.config/org.peer2profit.peer2profit.ini"

if [ -z "$PEER2PROFIT_EMAIL" ]; then
    echo "Please specify account email address via PEER2PROFIT_EMAIL=<email>"
    exit 1
fi
if [ ! -f $P2P_CONFIG ]; then
    echo "Creating config..."
    tee $P2P_CONFIG <<END
[General]
StartOnStartup=true
hideToTrayMsg=true
locale=en_US
Username=$PEER2PROFIT_EMAIL
installid2=$(cat /proc/sys/kernel/random/uuid)
END
    echo -n
fi

echo "Staring Peer2Profit..."
xvfb-run peer2profit
