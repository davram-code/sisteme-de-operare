#!/bin/bash

printf "Script name is $0"
count=$(ps -o comm | tail -n+2 | grep "^dont_execute$" | wc -l)

if [[ $count -gt 0 ]]
then
	printf "process 'dont_execute' executes\n"
	exit -1
fi

if [[ -d ~/logs ]]
then 
	printf "Directorul ~/logs exista deja\n"
	
	has_perm=$(ls -ld ~/logs | egrep "^drwx" | wc -l) # 1 has, 0 it has't
	
	if [[ $has_perm -eq 0 ]]
	then
		printf "Nu are permisiuni\n"
		exit -2
	else
		printf "Dir exista si are permisiunile corecte\n"
	fi

	owner=$(stat -c "%U" ~/logs)
	if [[ $owner != $(whoami) ]]
	then
		printf "userul nu e owner"
		exit -2
	fi
else
	mkdir -m 700 ~/logs
fi

while true
do
	current_date=$(date +%d-%m-%Y)
	log_filename=~/logs/logs-$current_date.txt
	touch $log_filename	
	
	current_time=$(date +%H:%m:%S)
	declare -i proc_no=$(ps -elf |wc -l)
	proc_no=proc_no-1
	user_no=$(cat /etc/passwd | wc -l)
	file_no=$(find ~/Documents -size +100M | wc -l)	

	echo "$current_time,$proc_no,$user_no,$file_no" >> $log_filename
		
	sleep 5
done
