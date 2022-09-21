#!/bin/bash

echo "#1"
egrep " > 10.3.* " traffic.txt

echo "#2"
sed -r "s/(IP [0-9]{1,3}\.)[0-9]{1,3}(\.[0-9]{1,3}\.[0-9]{1,3})/\1*\2/g" traffic.txt

echo "#3"
ips=$(cut -f3,5 traffic.txt -d" " | egrep -o "([0-9]{1,3}\.)[0-9]{1,3}(\.[0-9]{1,3}\.[0-9]{1,3})")

for ip in $ips
do
    ping -c3 $ip

    #4
    if ip a | egrep -o "inet.? ([^ ]*) " | egrep $ip
    then
        echo IP $ip is set on an interface
    fi
done

echo "#5"

dims=$(egrep -o "win [0-9]+" traffic.txt |cut -f2 -d" ")
declare -i sum=0
for i in $dims
do
    sum=$sum+$i
done

echo Traffic sum is $sum

nr=$(egrep -c "(\.22 >|\.22: Flags)" traffic.txt )
if [[ $nr -gt 0 ]]
then
    echo Avem traffic ssh
fi
