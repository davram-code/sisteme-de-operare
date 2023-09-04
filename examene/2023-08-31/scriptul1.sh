#!/bin/bash
function can_login() {
    password=$(sudo grep -E "^$1:" /etc/shadow | cut -f2 -d:)
    
    if [[ "$password" == "!" ||  "$password" == "!!" || "$password" == "*"  ]]
    then
        echo "Utilizatoru $1 nu are parolă setată. Doriți să setați una? (y/n)"
        read ans

        if [[ "$ans" = "y" || "$ans" = "Y" ]]
        then 
            sudo passwd $1
        fi
        return 1
    fi
        
    if echo -n $password | grep -Eq "!.+"
    then
        echo "Utilizatoru $1 este blocat. Doriți să îl deblocați? (y/n)"
        read ans

        if [[ "$ans" = "y" || "$ans" = "Y" ]]
        then 
            sudo usermod -U $1
        fi
        return 1
    fi

    return 0
}

if [[ $# -eq 1 ]]
then 
    if grep -Eq "^$1:" /etc/passwd
    then 
        if can_login $1
        then
            echo "user is not blocked and has paasword set"
        fi
    else
        echo "User does not exist"
    fi
fi

if [[ $# -eq 2 ]]
then 
    if [[ "$1" = "--proc" || "$2" = "--proc" ]]
    then
        values=$(ps -u "$1" -o vsz | tail -n+1)
        declare -i sum=0

        for i in $values
        do
            sum+=$i
        done

        ps -u $1
        exit 0
    fi

    if grep -Eq "^$1:" /etc/passwd && grep -Eq "^$2:" /etc/passwd
    then
        sudo groupadd studenti
        sudo usermod -aG studenti $1
        sudo usermod -aG studenti $2

        echo "Cale director: "
        read dir

        for file in $dir/*
        do
            owner=$(stat -c%u $file)
            if [[ -f "$file" && "$owner" = "$1" ]]
            then
                sudo chown "$2" $file
            fi
        done
    fi
fi

if [[ $# -ge 2 ]]
then 
    for user in $@
    do
        if grep -Eq "^$user:" /etc/passwd
        then
            name=$user
            home=$(grep -E "^$user:" /etc/passwd | cut -f6 -d: )
            grup_pp=$(id -ng "$user")
            shell=$(grep -E "^$user:" /etc/passwd | cut -f7 -d: )

            if [[ -n "$shell" ]]
            then
                echo "$name\$$home\$$grup_pp\$$shell"
            else 
                echo "$name\$$home\$$grup_pp"
            fi
        fi
    done
fi
