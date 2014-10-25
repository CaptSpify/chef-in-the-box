#
# Cookbook Name:: base-packages
# Recipe:: motd
# Still need to clean this up to be consistent. meh
#

execute "#!/bin/bash
# Better Tabs
tabs 2
# Define the filename to use as output
motd=\"/etc/motd\"
# Collect useful information about your system
# $USER is automatically defined
HOSTNAME=`uname -n`
KERNEL=`uname -r`
CPU=`grep \"model name\" /proc/cpuinfo | head -n 1 | awk '{print $9;}'`
ARCH=`uname -m`
DISK=`df -h | grep rootfs | awk '{print $5;}'`
MEMORY=`free -h | grep -E \"^Mem\" | awk '{print $4;}'`
DATE=`date +%Y.%m.%d.%H.%M`
# The different colours as variables
W=\"\033[01;37m\"
B=\"\033[01;34m\"
R=\"\033[00;31m\" 
G=\"\033[01;32m\" 
X=\"\033[00;37m\"
echo -n > $motd # to clear the screen when showing up
echo \"$R#========================================================#\" >> $motd
echo \" \t\t\t$W Welcome to $B$HOSTNAME        \" >> $motd
echo \"$B Arch   $W= $G$ARCH\t\t\t\t\t$B Disk Used\t$W= $G$DISK   \" >> $motd
echo \"$B Kernel $W= $G$KERNEL\t\t\t$B Memory\t\t\t$W= $G$MEMORY \" >> $motd
echo \"$B CPU    $W= $G$CPU\t\t\t\t$B Last Run\t\t$W= $G$DATE      \" >> $motd
echo \"$R#========================================================#\" >> $motd
echo \"$X\" >> $motd"
