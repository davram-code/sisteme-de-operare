#!/bin/bash

ps -eo comm,pid,%cpu | egrep "[0-9][0-9]\.[0-9]$"

echo :apps/scripturi
ps -e -o pid,comm | egrep "nmap$|nc$|sleep$|.*\.sh$"

# : utilizatori
echo "Utilizatori din root/adm/sudo"
cat /etc/group | egrep "^adm|^root|^sudo" | cut -f4 -d: | paste -s -d" " | sed "s/ //g"

echo "Implicit /bin/bash"
cat /etc/passwd | egrep ":/bin/bash$" | cut -f1 -d:



# : fisiere
echo Suid:
for i in $(echo $PATH | tr ":" " ")
do
	ls -l $i | egrep "^...(S|s)"
done

echo Password file
owner=$(stat -c %U /etc/shadow)
if [[ $owner != "root" ]]
then
    echo owner is not root
fi

if [[ $(stat -c %A /etc/shadow | tail -c4) == "---" ]]
then
    echo permisions are ---
fi
