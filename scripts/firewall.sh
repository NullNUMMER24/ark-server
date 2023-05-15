#!/bin/sh
if [[ $EUID -ne 0 ]]; then
     echo "This must be run as root"
     exit 1
fi
for port in 7777 7778 27015; do
    ufw allow $port/udp
done
#Uncomment the next if you want to open the default rcon port
#ufw allow 27020/tcp
