#!/bin/sh

touch /etc/aria2/aria2.session

config="/etc/aria2/aria2.conf"

if [ ! -f $config ]
then
    mv /root/aria2.conf $config
fi

if [ "$token" != "" ]
then
    sed -i "s/<token>/$token/g" $config
else
    sed -i "s/<token>/$(cat /proc/sys/kernel/random/uuid)/g" $config
fi

sh /root/update_trackers.sh

aria2c --conf-path=$config

