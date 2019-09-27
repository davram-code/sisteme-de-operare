#!/bin/bash

PS3='Please enter your choice: '
options=("Option 1" "Option 2" "Quit")
select opt in "${options[@]}"
do
    case $opt in
        "Option 1")
		read user -p "User = "
		read file -p "File = "

		ps -ef | grep "^$user"
		killall -s SIGKILL $file
            ;;
        "Option 2")
		read path
		if [[ -f $path ]]
		then
			stat --printf="Inode nr. = %i\nOwner =  %U\nHard links = %h \nLast access time = %x\n" $path
		else
			echo "Not a regular file."
		fi
            ;;
        "Quit")
	    exit 1
            break
            ;;
        *) echo "Invalid option $REPLY";;
    esac
done
