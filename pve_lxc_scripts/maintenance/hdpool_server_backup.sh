#!/bin/sh
#mv /hdpool/fs/log/server_backup.log /hdpool/fs/log/server_backup_prev.log
#rsync -avHPAX --delete /mnt/ssd-usb /hdpool/fs/server_backup &>/hdpool/fs/log/server_backup.log
#
# with exclusion support
#rsync -avHPAX --delete --exclude={'ssd-media/media/cache','ssd-data/dockerapps/vega/navidrome/data/cache', 'ssd-data/dockerapps/vega/lms/config/cache', 'ssd-data/dockerapps/vega/kavita/data/backups', 'ssd-data/dockerapps/blanka/youtube-dl/db', 'ssd-data/dockerapps/blanka/jdownloader2/config/xdg/cache', 'ssd-data/dockerapps/blanka/jdownloader2/config/tmp', 'ssd-data/dockerapps/blanka/jdownloader2/config/logs'} /mnt/ssd-usb /hdpool/fs/server_backup &>"/hdpool/fs/log/server_backup.$(date +'%Y-%m-%d').log"
#
# add all exclusion directories to the _exclude file below
rsync -avHPAX --delete --exclude-from='./hdpool_server_backup_exclude.txt' /mnt/ssd-usb /hdpool/fs/server_backup &>"/mnt/ssd-usb/pve_scripts/log/server_backup.$(date +'%Y-%m-%d').log"
