#!/bin/bash
set -euo pipefail

dnf -y install nginx amazon-cloudwatch-agent
cat >/opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json <<'EOF'
{
  "logs": {
    "logs_collected": {
      "files": {
        "collect_list": [{
          "file_path": "/var/log/nginx/access.log",
          "log_group_name": "${log_group_name}",
          "log_stream_name": "{instance_id}/access",
          "timezone": "UTC"
        }, {
          "file_path": "/var/log/nginx/error.log",
          "log_group_name": "${log_group_name}",
          "log_stream_name": "{instance_id}/error",
          "timezone": "UTC"
        }]
      }
    }
  }
}
EOF
echo 'Interview TF' >/usr/share/nginx/html/index.html
systemctl enable --now nginx
systemctl enable --now amazon-cloudwatch-agent
