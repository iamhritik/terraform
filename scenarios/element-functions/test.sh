#!/bin/bash

instances=("web1" "web2")
date=$(date +"%m-%d-%y")

for item in ${instances[@]}; do
    echo "running for this instance:-${item} ${date}" > /home/ubuntu/data.log
done
