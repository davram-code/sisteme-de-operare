#!/bin/bash

if [[ $# -ne 1 ]]
then
	echo Scriptul nu a primit fix un parametru 
	exit 1
fi

if [[ ! -f "$1" ]]
then
	echo "fisierul nu respecta cerinta"
	exit 1
fi

error_lines=$(cut -f6 -d, "$1"| egrep -c "ERROR:")
echo "Nr linii cu erori: $error_lines"

nrs=$(cut -f4 -d, $1)

declare -i sum=0
for i in $nrs
do
	sum=sum+$i
done
echo suma: $sum

nr_get=$(egrep "^[0-9][02468].*,GET," "$1" | wc -l)
echo Nr geturi: $nr_get

echo $(cut -f5 -d, $1| sed -r "s/([0-9]{1,3})(\.[0-9]{1,3}\.[0-9]{1,3}\.)([0-9]{1,3})/\3\2\1/g")

while read line
do
	path=$(echo $line | cut -f3 -d,)
	is_pt=$(echo $path | grep -c "/\.\./")

	if [[ $is_pt -gt 0 ]]
	then
		echo "ATENTIE, PATH TRAVERSAL: $(echo $line | cut -f1,3 -d,)"
	fi
done < $1

