#!/bin/bash
date=$(date +%Y.%m.%d)
year=$(date +%Y)
month=$(date +%m)
day=$(date +%d)
hour=$(date +%H)

if [ "$1" == "-t" ];
then
  test=true
fi

# All hosts
general_filter_list="/USR/SBIN/CRON\[[0-9]*\]: \(root\) CMD \(  \[ -x /usr/lib/php5/maxlifetime \] \&\& \[ -d /var/lib/php5 \] \&\& find /var/lib/php5/ -depth -mindepth 1 -maxdepth 1 -type f -ignore_readdir_race -cmin \+\\$\(/usr/lib/php5/maxlifetime\)\$"
general_filter_list="$general_filter_list|/USR/SBIN/CRON\[[0-9]*\]: \(root\) CMD \(   cd / \&\& run-parts --report /etc/cron.(hourly|daily|weekly|monthly)\)\$"
# web
web_filter_list="|web /USR/SBIN/CRON\[[0-9]*\]: \(root\) CMD \(  \[ -x /usr/lib/php5/maxlifetime \] \&\& \[ -x /usr/lib/php5/sessionclean \] \&\& \[ -d /var/lib/php5 \] \&\& /usr/lib/php5/sessionclean /var/lib/php5 .*\(/usr/lib/php5/maxlifetime\)\)\$"

# chef
chef_filter_list="chef1 /usr/sbin/cron\[[0-9]*\]: \(*system*rabbitmq-server\) RELOAD \(/etc/cron.d/rabbitmq-server\)\$"

# repo1
repo_filter_list="repo1 /USR/SBIN/CRON\[[0-9]*\]: \(root\) CMD \(  \[ -x /usr/lib/php5/maxlifetime \] \&\& \[ -x /usr/lib/php5/sessionclean \] \&\& \[ -d /var/lib/php5 \] \&\& /usr/lib/php5/sessionclean /var/lib/php5 .*\(/usr/lib/php5/maxlifetime\)\)\$"

# Ensure the needed directories exist
if [ ! -d /tmp/syslog ];
then
  mkdir /tmp/syslog
fi
# Make sure this is clean
rm -rf /tmp/syslog/*

if [ ! -d /var/log/rsyslog/filtered/$date ];
then
  mkdir -p /var/log/rsyslog/filtered/$date
fi

work_dir="/var/log/rsyslog/$year/$month/$day"

for host in $(ls $work_dir)
do
  # Move them to /tmp and then filter them
  for file in $(ls $work_dir/$host/)
  do
    case $host in
    web)
      filter_list="$general_filter_list|$web_filter_list"
      ;;
    chef)
      filter_list="$general_filter_list|$chef_filter_list"
      ;;
    *)
      filter_list="$general_filter_list"
      ;;
    esac
    # Go go gadget filter
    grep -iEv "$filter_list" $work_dir/$host/$file > /tmp/syslog/$host.$file
    grep -iE "$filter_list" $work_dir/$host/$file > /var/log/rsyslog/filtered/$date/$host.filtered.log
  done
  
  # find non-empty files
  if [ -n "$test" ];
  then
    cat /tmp/syslog/*
  else
    files_to_send=$(find /tmp/syslog/ -type f -not -empty -print)
    if [ -n "$files_to_send" ]; 
    then
      echo "" | mutt -s "$host logs - $date" admin@example.com -a $files_to_send
    fi
  fi

  # Clear it all out for the next run
  rm -rf /tmp/syslog/*
done
