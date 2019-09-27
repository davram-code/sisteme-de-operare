#!/bin/bash

echo "1:"
cut -f3 -d: /etc/passwd

echo "2:"
read -p "Introduceti fisier: " file  
grep -o "\b[a-zA-Z]*ing\b" $file


echo "3:"
grep -o "\b7[0-9]*\b" $file

echo "4:"
grep -r "student" ~

echo "5:"
nr=$(grep -oc "https\?://\(www.\)\?[a-zA-Z0-9_-]*\.[a-zA-Z]\{2\}[a-zA-Z]\?" $file)
echo "nr de aparitii site web: $nr"

