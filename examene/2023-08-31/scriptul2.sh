#!/bin/bash
start=$(date +%s)

# We use these to keep track of arguments
quiet=0
check_files=0
check_meta=0
check_full=0
init=0
meta_file=""
checksum_file=""
dir=""

working_dir=$(pwd)

return_code=0

declare -i file_no=0
declare -i file_dim=0

# This could be hardcoded, but this is nicer :)
function parse_args() {
    for arg in $@
    do
        case $arg in
            '-q') quiet=1 ;;
            '--init') init=1 ;;
            '--check-files') check_files=1 ;;
            '--check-metadata') check_meta=1 ;;
            '--check-full') check_full=1 ;;
            *)  
                # If we have --check-files or --check-meta we only have one file and the dir
                if [[ $check_files = 1 || $check_meta = 1 ]]
                then 
                    if [[ -z "$meta_file" ]]
                    then
                        meta_file=$arg
                    else 
                        dir=$arg
                    fi
                fi

                if [[ $check_full = 1 || $init = 1 ]]
                then 
                    if [[ -z "$checksum_file" ]]
                    then
                        checksum_file=$arg
                    elif [[ -z "$meta_file" ]]
                    then
                        meta_file=$arg
                    else
                        dir=$arg
                    fi
                fi
                ;;
        esac
    done

}

function init() {
    cd $dir

    # Iterate through files in given directory. 
    # Could also be done with "files=$(ls -R test | tr -d ':' | sed '/\./d' )" but this is better
    find . | while read file 
    do

        # Get file type
        file_type=$(ls -ld $file | head -c1)

        if [[ "$file_type" = "-" ]]
        then
            checksum=$(sha256sum "$file" | cut -f1 -d" ")
            echo "$file,$file_type,$checksum" >> $checksum_file
        elif [[ "$file_type" = "l" ]]
        then
            dest_name=$(ls -ld $file | rev | cut -f1 -d " " | rev)
            echo "$file,$file_type,$dest_name" >> $checksum_file
        else
            echo "$file,$file_type," >> $checksum_file
        fi

        # Metadata file
        name=$file
        dim=$(stat -c%s $file)
        modif=$(stat -c%y $file)
        perm=$(stat -c%a $file)
        owner=$(stat -c%U $file)
        gowner=$(stat -c%G $file)

        echo "$name,$dim,$modif,$perm,$owner,$gowner" >> $meta_file
    done
    
    cd - > /dev/null

    return 0
}

parse_args $@

# If relative paths, convert to absolute paths
if [[ -n $meta_file && ${meta_file:0:1} != '/' ]]
then
    meta_file=$(realpath $meta_file)
fi
if [[ -n $checksum_file && ${checksum_file:0:1} != '/' ]]
then
    checksum_file=$(realpath $checksum_file)
fi


if [[ $init = 1 ]]
then
    # Remove files if they already exist
    [[ -f "$meta_file" ]] && rm $meta_file
    [[ -f "$checksum_file" ]] && rm $checksum_file
    init
else
    cd $dir
    while read line
    do
        file=$(echo $line | cut -f1 -d,)
        if [[ ! -e "$file" ]]
        then
            [[ $quiet = 0 ]] && echo $file does not exist!
            return_code=1

            # If not exist, we shouldn't check any further
            continue
        fi
        
        # If we have --check-files we should stop here
        if [[ $check_files = 1 ]]
        then
            continue
        fi

        dim=$(stat -c%s $file)
        modif=$(stat -c%y $file)
        perm=$(stat -c%a $file)
        owner=$(stat -c%U $file)
        gowner=$(stat -c%G $file)

        check_dim=$(echo $line | cut -f2 -d,)
        check_modif=$(echo $line | cut -f3 -d,)
        check_perm=$(echo $line | cut -f4 -d,)
        check_owner=$(echo $line | cut -f5 -d,)
        check_gowner=$(echo $line | cut -f6 -d,)

        if [[ "$dim" !=  $check_dim ]]
        then 
            # if -q is not set, print info
            [[ $quiet = 0 ]] && echo $file incorrect dimension $dim, expected $check_dim
            return_code=1
        fi

        if [[ "$modif" !=  "$check_modif" ]]
        then 
            [[ $quiet = 0 ]] && echo $file incorrect modif time $modif, expected $check_modif
            return_code=1
        fi

        if [[ "$perm" !=  "$check_perm" ]]
        then 
            [[ $quiet = 0 ]] && echo $file incorrect perm $perm, expected $check_perm
            return_code=1
        fi

        if [[ "$owner" !=  "$check_owner" ]]
        then 
            [[ $quiet = 0 ]] && echo $file incorrect owner $owner, expected $check_owner
            return_code=1
        fi

        if [[ "$gowner" !=  "$check_gowner" ]]
        then 
            [[ $quiet = 0 ]] && echo $file incorrect gowner $gowner, expected $check_gowner
            return_code=1
        fi
        
        # If we have --check-metadata we should stop here
        if [[ $check_meta = 1 ]]
        then
            continue
        fi

        file_type=$(grep -E "^$file," $checksum_file|cut -f2 -d,)
        if [[ "$file_type" = "-" ]]
        then
            checksum=$(sha256sum "$file"  | cut -f1 -d" ")
            check_checksum=$(grep -E "^$file," $checksum_file|cut -f3 -d,)

            if [[ "$checksum" != "$check_checksum" ]]
            then
                [[ $quiet = 0 ]] && echo $file: incorrect checksum $checksum, expected $check_checksum
                return_code=1
            fi
        fi

    done < $meta_file
    cd - >/dev/null
fi

# To check running time
sleep 2

# `date +%s` gives seconds since the Epoch, so if we substract from the beggining we 
# get the execution time in seconds
stop=$(date +%s)

# We can use metadata file for this, because it's available in every case
file_no=$(wc -l $meta_file |cut -f1 -d" ")
for size in $(cut -f2 -d, $meta_file)
do
    file_dim+=$size
done

run_time=$(($stop-$start))
echo $(date), $file_no, $file_dim, $run_time >> log

exit $return_code
