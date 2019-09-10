#!/bin/bash
#author :Dan Avram

function info_text
{
    read -p "Input file: " file
    hard_links=$(stat -c "%h" $file) 
    inode=$(stat -c "%i" $file) 
    mtime=$(stat -c "%y" $file) 

    echo -e "Hard links: $hard_links\nInode number: $inode\nModified time:$mtime"

}

function ex2
{
    read -p "Input file: " file
    cp $file $file.bkp

    sed -ri "s/([a-z])([.a-z]+)(@[a-z]+.[a-z]+)/\1***\3/g" $file
}

function ex3
{
    read folder -p "Input folder"
    if [[ -n $folder  ]]
    then
        if [[ ! -d $folder ]]
        then
            echo "Not a folder"
            return
        fi
    else
        return
    fi

    user=$(cat /etc/passwd | cut -f1 -d: | grep "^student$")
    if [[ -z $user ]]
    then
        sudo useradd $user
    fi

    user=$(cat /etc/passwd | cut -f1 -d: | grep "^student123$")
    if [[ -z $user ]]
    then
        sudo useradd $user
    fi

    user=$(cat /etc/passwd | cut -f1 -d: | grep "^student987$")
    if [[ -z $user ]]
    then
        sudo useradd $user
    fi    

    group=$(cat /etc/group | cut -f1 -d: | grep "^group123$")
    if [[ -z $user ]]
    then
        sudo groupadd $group
    fi

    group=$(cat /etc/group | cut -f1 -d: | grep "^student$")
    if [[ -z $user ]]
    then
        sudo groupadd $group
    fi

    cd $folder
    ln -s /bin/bash bash
    touch fis1 fis2
    mkdir dir1 dir2

    sudo chown student:student bash
    sudo chown student:student dir1
    sudo chown student123:group123 dir2
    sudo chown student:student fis1
    sudo chown student987:group123 fis2

    sudo chmod u=rwx,g=rx,o=rx dir1
    sudo chmod u=rwx,g=rx,o=rt dir2
    sudo chmod u=rws,g=rs,o=rx fis1
    sudo chmod u=rws,g=rws,o=rwt fis2
}

PS3="Alege o optiune din meniu"
select ITEM in "Subpunctul 2" "Subpunctul 3" "Subpunctul 4" "Exit"
do
case $REPLY in
    1) info_text ;;
    2) ex2 ;;
    3) ex3 ;;
    4) exit 0 ;;
esac
done
