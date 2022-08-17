#!/bin/bash
sudo apt update -y
sudo apt install apache2 -y
sudo apt install net-tools -y
sudo systemctl restart apache2
echo "Done" > /home/ubuntu/done.log