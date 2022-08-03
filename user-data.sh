#!/bin/bash
echo "Hello world" > index.html
nohup busybox httpd -f -p ${server_port} &