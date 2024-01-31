#!/bin/bash
#Copyright (c) 2023 Woshishee

# Check if UUID environment variable is set
if [ -z "$PROXYRACK_UUID" ]; then
    echo "Please set the PROXYRACK_UUID environment variable."
    exit 1
fi

# Check internet access.
echo -e "GET http://peer.proxyrack.com HTTP/1.0\n\n" | nc peer.proxyrack.com 443 > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo "Welcome to Proxyrack!"
else
    echo "Please check your internet connection and try again."
fi

function start_proxyrack() {
	echo "Updating Proxyrack..."
	rm -rf script.js
	wget https://app-updates.sock.sh/peerclient/script/script.js
	echo "Update done!"
	node script.js --homeIp point-of-presence.sock.sh --homePort 443 --id $PROXYRACK_UUID --version $(curl --silent https://app-updates.sock.sh/peerclient/script/version.txt) --clientKey proxyrack-pop-client --clientType PoP 
	#node script.js --homeIp point-of-presence.sock.sh --homePort 443 --id $PROXYRACK_UUID --version 56 --clientKey proxyrack-pop-client --clientType PoP 
}

echo "Using provided PROXYRACK_UUID: $PROXYRACK_UUID"
start_proxyrack &


while true; do sleep 1; done

