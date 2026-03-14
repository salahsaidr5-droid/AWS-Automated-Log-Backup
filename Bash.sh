#!/bin/bash

set -x

DATE=$(date +%F-%H-%M)
WEB_SERVER_IP="10.0.1.242"
WEB_SERVER_USER="ec2-user"
SSH_KEY="/home/ec2-user/web-key.pem"

REMOTE_LOG_PATH="/var/log/httpd"
LOCAL_BACKUP_DIR="/home/ec2-user/backups/logs"
ARCHIVE_NAME="logs-backup-$DATE.tar.gz"
S3_BUCKET="s3://that-bucket-s3-project/logs"

mkdir -p "$LOCAL_BACKUP_DIR"

 ssh -i "$SSH_KEY" \
  -o StrictHostKeyChecking=no \
  -o UserKnownHostsFile=/dev/null \
  ${WEB_SERVER_USER}@${WEB_SERVER_IP} \
  "sudo tar -czf - ${REMOTE_LOG_PATH}" \
  > "${LOCAL_BACKUP_DIR}/${ARCHIVE_NAME}"

aws s3 cp "${LOCAL_BACKUP_DIR}/${ARCHIVE_NAME}" "${S3_BUCKET}/"

find "$LOCAL_BACKUP_DIR" -type f -name "*.tar.gz" -mtime +7 -delete

echo "Backup completed: ${ARCHIVE_NAME}"
