#!/bin/bash
# Get the md5sum
repos=$(echo "www" "blog")
for repo in $repos; do 
  md5stamp=$(GET http://repo1.example.com/stamp.$repo | awk '{print $1;}')
  md5tmp=$(/usr/bin/md5sum /tmp/$repo.tgz | awk '{print $1;}')
  date=$(date +%Y.%m.%d.%H.%M)
  log="/var/log/www-pull.log"

# compare them
  if [ "$md5tmp" != "$md5stamp" ]; 
  then
    # Pull the new version
    echo "$date: Grabbing new $repo file" >> $log 2>&1
    wget -qO /tmp/$repo.tgz http://repo1.example.com/$repo.tgz
    echo "$date: $repo Grabbed. Unzipping" >> $log 2>&1
    rm -r /var/$repo/*
    tar -xf /tmp/$repo.tgz -C /
    chown -R www-data:www-data /var/$repo
    echo "$date: $repo Unzipped. We're all done here" >> $log 2>&1
  else
    echo "$date: the $repo md5 matches" >> $log 2>&1
  fi

done
