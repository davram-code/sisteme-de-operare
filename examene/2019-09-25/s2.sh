#!/bin/bash

read path -p "Introduceti calea catre director: "

echo "1:"
if [[ ! -d $path ]]
then 
	echo "$path nu este director"
else
	find $path -type f -user root
fi

echo "2:"

full_path=$(realpath "$path")
find $full_path -path "*student*"

echo "3:"
read file -p "Introduceti fisier: "
sed "s/07[0-9]\{8\}/07********/g" $file

echo "4:"
read prop
echo $prop | tr [a-z] [A-Z] 

