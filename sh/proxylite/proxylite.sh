#!/bin/bash

function removeProxyLite() {
	echo "Removing ProxyLite";
	
	if [[ -d /usr/local/proxylite ]]; then
		systemctl stop proxylite;
		systemctl disable proxylite;
		echo "Removing folders";
		rm -rf /usr/local/proxylite;
		echo "Removing systemd daemon";
		rm /etc/systemd/system/proxylite.service
		systemctl daemon-reload
	else
		echo "ProxyLite not installed";
	fi
}

function installProxyLite() {
echo "Checking ProxyLite Installation";

if ! [[ -d /usr/local/proxylite ]]; then
	echo "Creating folders";
	
	mkdir /usr/local/proxylite
	mkdir /usr/local/proxylite/dotnet60
	mkdir /usr/local/proxylite/service
	echo $1 > /usr/local/proxylite/service/userid.ini
	
	echo "Downloading .NET 6.0"
	wget https://app.proxylite.ru/thirdparty/dotnet-runtime-6.0.10-linux-x64.tar.gz -P /usr/local/proxylite/dotnet60 2> /dev/null 1>/dev/null
	echo "Downloading ProxyService"
	wget https://app.proxylite.ru/netcoreapp-latest.tar -P /usr/local/proxylite/service 2> /dev/null 1>/dev/null
	echo "Unpacking .NET 6.0"
	tar xf /usr/local/proxylite/dotnet60/dotnet-runtime-6.0.10-linux-x64.tar.gz -C /usr/local/proxylite/dotnet60
	rm /usr/local/proxylite/dotnet60/dotnet-runtime-6.0.10-linux-x64.tar.gz
	chmod +x /usr/local/proxylite/dotnet60/dotnet
	echo "Unpacking ProxyService"
	tar xf /usr/local/proxylite/service/netcoreapp-latest.tar -C /usr/local/proxylite/service
	rm /usr/local/proxylite/service/netcoreapp-latest.tar
	
	echo "Creating systemd daemon"
	echo '[Unit]
Description=ProxyLite ProxyService
After=network.target

[Service]
StartLimitInterval=0
StandardOutput=null
LimitNOFILE=1008575
Restart=always
RestartSec=8
WorkingDirectory=/usr/local/proxylite/service
ExecStart=/usr/local/proxylite/dotnet60/dotnet /usr/local/proxylite/service/ProxyService.Core.dll

[Install]
WantedBy=multi-user.target' > /etc/systemd/system/proxylite.service;
	echo "Reloading systemd daemons"
	systemctl daemon-reload
	echo "Enabling ProxyLite daemon"
	systemctl enable proxylite
	echo "Starting ProxyLite daemon"
	systemctl start proxylite
	
	echo "Successfily! You are installed ProxyLite on this system. You can check install by 'systemctl status proxylite'"
	echo "If you want stop ProxyLite, you can use 'systemctl stop proxylite'"
	echo "If you want remove ProxyLite, you should start this script with 'uninstall' argument"
	
else
	echo "ProxyLite already installed";
	current_id=$(cat /usr/local/proxylite/service/userid.ini);
	
	if [[ $current_id != $1 ]]; then
		echo "Presented ID $1 is not match by current $current_id";
		echo "Restarting service";
		echo $1 > /usr/local/proxylite/service/userid.ini
		systemctl restart proxylite
		
	fi
fi

}
if [[ `whoami` != 'root' ]]; then echo "You should be root, to perform this operation."; echo 'Please, try start this script as root user, or with sudo';  exit; fi;
# if ! which systemctl >/dev/null 2>1; then echo "System is not SystemD"; exit; fi;
if ! which tar >/dev/null 2>1; then echo "Package 'tar' is not installed (command not found)"; exit; fi;
if ! which wget >/dev/null 2>1; then echo "Package 'wget' is not installed (command not found)"; exit; fi;
if ! which cat >/dev/null 2>1; then echo "Package 'cat' is not installed (command not found)"; exit; fi;
if ! which rm >/dev/null 2>1; then echo "Package 'rm' is not installed (command not found)"; exit; fi;

if [[ $1 = "uninstall" ]]; then
	removeProxyLite
elif [[ $1 == "stop" ]]; then
	echo "Stopping ProxyLite Service";
	systemctl stop proxylite
else 
	if [[ $1 != "" ]] && (( $1 > 0 )); then 
		installProxyLite $1
	else
		read -p "Please, specify the your user id (should be numeric) (you can find it on https://lk.proxylite.ru): " id;
		
		if [[ $id != "" ]] && (( $id > 0 )); then 
			installProxyLite $id
		else
			echo "User ID should be numeric. Please, restart this script $id";
		fi
	fi
fi

/usr/local/proxylite/dotnet60/dotnet /usr/local/proxylite/service/ProxyService.Core.dll
