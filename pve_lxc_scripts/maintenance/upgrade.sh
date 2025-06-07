#!/bin/bash

fullclean() 
{
  sudo apt clean
  sudo apt autoclean
  sudo apt autoremove
}

fullupdate()
{
  sudo apt update
  sudo apt dist-upgrade
  
  #pve server only
  if [ -x "$(command -v pveversion)" ]; then
    sudo fwupdate
  fi  
}

#intended to be run on PVE guests only
dockerupdateall()
{
    if [ ! -x "$(command -v pveversion)" ]; then #ensure it's not the server 
      if [ -x "$(command -v docker)" ]; then #ensure docker is installed on the host 
        cd /mnt/pve-sata-ssd/ssd-data/dockerapps || exit
        cd "$(hostname)" || exit
        find . -maxdepth 1 -type d \( ! -name . \) -not -path '*disabled*' -exec bash -c "cd '{}' && pwd && docker compose down && docker compose pull && docker compose up -d --remove-orphans" \;
        docker image prune -a -f
        docker system prune --volumes -f
     fi
    fi
}

#main
fullupdate
fullclean
dockerupdateall

