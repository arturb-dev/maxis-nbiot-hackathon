#!/bin/sh

YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[1;34m'
SET='\033[0m'

apt-get update
apt-get install ppp tmux -y

echo "${YELLOW}What is your carrier APN?${SET}"
read carrierapn 

echo "${YELLOW}What is your device communication PORT? (ttyS0/ttyUSB3/etc.)${SET}"
read devicename 

mv chat-connect /etc/chatscripts/
mv chat-disconnect /etc/chatscripts/

mkdir -p /etc/ppp/peers
sed -i "s/#APN/$carrierapn/" provider
sed -i "s/#DEVICE/$devicename/" provider
mv provider /etc/ppp/peers/provider

if ! (grep -q 'route' /etc/ppp/ip-up ); then
    echo "sudo route del default" >> /etc/ppp/ip-up
    echo "sudo route add default ppp0" >> /etc/ppp/ip-up
fi
			  
systemctl daemon-reload

echo "${YELLOW}Do you want to activate auto connect/reconnect service at R.Pi boot up? [Y/n] ${SET}"
read auto_reconnect
while [ 1 ]
do
	case $auto_reconnect in
		[Yy]* )    echo "${YELLOW}Downloading setup file${SET}"
		
			mv reconnect.sh /usr/src/
			mv nbiot.service /etc/systemd/system/
			  
			systemctl daemon-reload
			systemctl enable reconnect.service
			  
			break;;
			  
		[Nn]* )    echo "${YELLOW}To connect to internet run ${BLUE}\"sudo pon\"${YELLOW} and to disconnect run ${BLUE}\"sudo poff\" ${SET}"
			  break;;
		*)   echo "${RED}Wrong Selection, Select among Y or n${SET}";;
	esac
done

read -p "Press ENTER key to reboot" ENTER
reboot
