#!/bin/bash

sudo apt-get install -y gparted calibre

sudo groupadd profesori
sudo groupadd studenti
sudo groupadd FacA
sudo groupadd FacB
sudo groupadd FacC
sudo groupadd FacD

while read line
do
    nr=$(echo $line | cut -f1 -d,)
    nume=$(echo $line| cut -f2 -d, | cut -f1 -d" ")
    prenume=$(echo $line| cut -f2 -d, | cut -f2 -d" ")
    facultate=$(echo $line| cut -f3 -d,)
    nume=${nume,,}
    prenume=${prenume,,}
    facultate=${facultate,,}

    username=${facultate}_${prenume:0:1}${nume}
    sudo useradd -m -d /home/studenti/${username} -g studenti -G Fac${facultate^^} ${username}
    mkdir -p "/tmp/$username"

    sudo chown $username "/tmp/$username"
    sudo chmod 700 "/tmp/$username"
    echo "Hello $username" > readme.tmp
    sudo mv readme.tmp /home/studenti/${username}/Readme
done < studenti.txt

while read line
do
    nume=$(echo $line| cut -f1 -d, | cut -f1 -d' ')
    prenume=$(echo $line | cut -f1 -d, | cut -f2 -d" ")
    grupe=$(echo $line| cut -f2 -d, | sed -r "s/([A-Z])/Fac\1/g" | tr : ",")

    sudo useradd -m -d /home/profesori/${username} -g profesori -G $grupe,sudo ${username}
    mkdir -p "/tmp/$username"
    sudo chown $username "/tmp/$username"
    sudo chmod 700 "/tmp/$username"

done < profesori.txt

#tmp 
mkdir /tmp/profesori
mkdir /tmp/studenti

sudo chown root:studenti /tmp/studenti
sudo chown root:profesori /tmp/profesori

sudo chmod 070 /tmp/profesori
sudo chmod 575 /tmp/studenti


