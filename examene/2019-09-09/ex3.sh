#!/bin/bash
#author     :Dan Avram

if ! [[ $# -eq 2 ]]
then
    exit 1
fi

if echo $2 | grep -E "^([0-9]{1,3}\.){3}[0-9]{1,3}$"
then 
    echo "ip correct"
else
    echo "ip not correct"
fi

if [[ -f $1 ]]
then

    send=$(grep -c "^s" $1)
    echo "Nr. de pachete transmise: $send"

    http=$(cut -f4 -d"," $1| grep -c "80")
    echo "Nr. de pachete HTTP receptionate: $http"

    declare -i total=0
    for i in $(grep $2 traffic.csv | cut -f6 -d",")
    do
        total=$total+$i
    done
    echo "Traficul total de date: $total bytes"
else
    exit 1
fi

