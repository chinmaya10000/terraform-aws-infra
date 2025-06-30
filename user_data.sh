#!/bin/bash
set -ex
yum update -y
yum install -y nginx
systemctl enable nginx
systemctl start nginx
echo "<h1>Hello, World from $(hostname -f)</h1>" > /usr/share/nginx/html/index.html
