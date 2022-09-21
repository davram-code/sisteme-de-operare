#!/bin/bash

sudo useradd -m -d /home/avram avram
sudo groupadd c112a
sudo usermod -g c112a avram
sudo usermod -aG sudo avram

sudo mkdir -m 755 /home/avram/teme
sudo chown avram:c112a /home/avram/teme

sudo mkdir -m 740 /home/avram/examene
sudo chown root:root /home/avram/examene

sudo mkdir /home/avram/aplicatii
sudo ln -s -T /bin/bash /home/avram/teme/bash

sudo cp /bin/ls /home/avram/aplicatii
sudo chown root /home/avram/aplicatii/ls
sudo chmod u+s /home/avram/aplicatii/ls

