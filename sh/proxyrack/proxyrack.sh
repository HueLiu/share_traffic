#!/bin/bash
#Copyright (c) 2023 Woshishee

echo "Version: 18 March 2024\n";

# Check if PROXYRACK_UUID environment variable is set
if [ -z "$PROXYRACK_UUID" ]; then
    echo "Please set the PROXYRACK_UUID environment variable."
    exit 1
fi

# Set env.
export api_file=/app/api.cfg

# Check internet access.
#echo -e "GET http://peer.proxyrack.com HTTP/1.0\n\n" | nc peer.proxyrack.com 443 > /dev/null 2>&1
nc -z point-of-presence.sock.sh 443
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

function add_device() {
	echo "Adding device to dashboard..."
	sleep 2m
	curl -X POST https://peer.proxyrack.com/api/device/add -H "Api-Key: ${api_key}" -H 'Content-Type: application/json' -H 'Accept: application/json' -d '{"device_id":"'"$PROXYRACK_UUID"'","device_name":"'"$device_name"'"}'
}

echo "Using provided PROXYRACK_UUID: $PROXYRACK_UUID"
start_proxyrack &

#if [ -f "$api_file" ]; then
#	echo "$api_file already exists."
#else
#	echo "$api_file does not exist."
#	if [[ "$device_name" ]]; then
#		echo "Device name is set."
#		if [[ "$api_key" ]]; then
#			echo "Api key is set."
#			add_device &
#		else
#			echo 'No api key set.'
#		fi
#	else
#		echo 'No device name set.'
#	fi
#fi

while true; do sleep 1; done
