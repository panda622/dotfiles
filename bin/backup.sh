#!/bin/sh
mkdir -p /home/backup

tar --exclude "node_modules/*" --exclude "tmp/cache/*" -zcvf  "/home/backup/$(date +"%Y-%m-%d")-backup.tgz" /mnt/blockstorage

mkdir -p /root/.config/rclone
cp /mnt/blockstorage/user/.config/rclone/rclone.conf /root/.config/rclone
rclone copy "/home/backup/$(date +"%Y-%m-%d")-backup.tgz" dropbox-encrypted:/linux/backup

exit
