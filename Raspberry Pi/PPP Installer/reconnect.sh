#!/bin/sh

while true; do

        ping -I ppp0 -c 1 8.8.8.8 -s 0

        if [ $? -eq 0 ]; then
                echo "Connection up, reconnect not required..."
        else
                echo "Connection down, reconnecting..."
                sudo pon
                sleep 1
                ##sudo ifconfig wwan0 down
                sleep 1
                sudo route del default
                sleep 1
                sudo route add default ppp0
        fi

        sleep 15
done
