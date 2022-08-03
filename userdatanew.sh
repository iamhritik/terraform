#!/bin/bash
echo "Hello world 2" > index.html
nohup busybox httpd -f -p ${server_port} &