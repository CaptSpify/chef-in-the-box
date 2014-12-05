#
# Cookbook Name:: scripts
# Recipe:: default
#

# Remove uneeded package
pkgs_to_purge= %w{ mpt-status laptop-detect }
  
pkgs_to_purge.each do |pkg|
  dpkg_package pkg do
    action :purge
  end
end

### Get the vimrc files and put them in the home dir
# root
cookbook_file "/root/.vimrc" do
  source "vimrc"
  owner "root"
  group "root"
  mode 0700
end

cookbook_file "/root/.bashrc" do
  source "bashrc"
  owner "root"
  group "root"
  mode 0700
end

# I know, I know. This could be handled much better, but fuckit
# CaptSpify
cookbook_file "/home/CaptSpify/.vimrc" do
  source "vimrc"
  owner "CaptSpify"
  group "CaptSpify"
  mode 0700
end

cookbook_file "/home/CaptSpify/.bashrc" do
  source "bashrc"
  owner "CaptSpify"
  group "CaptSpify"
  mode 0700
end

directory "/mnt/Backups" do
  not_if { File.exist?("/mnt/Backups") }
  owner "root"
  group "root"
  mode  "755"
  action :create
end

mount "/mnt/Backups" do
  device "//backupserver.example.com/Backups"
  fstype "cifs"
  options "username=username,password=password,users,_netdev,suid,exec,dev,file_mode=0774"
end
