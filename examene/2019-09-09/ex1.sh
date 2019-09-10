#!/bin/bash
#author     :Dan Avram

if [[ $# -eq 1 ]]
then
    if [[ -d $1 ]]
    then
        owner=$(stat -c "%U" $1)
        echo "The owner of $1 is $owner"
        
        less=$(find $1 -size -1048576c -type f |wc -l)
        more=$(find $1 -size +1048576c -type f |wc -l)

        echo "The folder has $less files with size <1MB and $more files with size >1MB"

        echo "Fisiere cu extensia .sh:"
        find $1 -name "*.sh" -exec wc -l {} \;
        
        echo Dimensiunea totala:
        du -sh $1| cut -f1 
    else
        echo "Not a folder"
    fi

else
    echo "usage: $0 {folder}"
    exit 1
fi
