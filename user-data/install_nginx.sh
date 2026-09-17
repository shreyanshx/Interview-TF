#!/bin/bash
yum -y install nginx
systemctl enable --now nginx
echo "Interview TF" >/usr/share/nginx/html/index.html
