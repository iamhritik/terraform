#!/bin/bash

sudo apt update -y
#script in remote-exec copy local file into remote server ,then run it and  delete it
sudo cp test.sh backup-test.sh
sudo echo "hello world from local side| $(pwd)"> test.html