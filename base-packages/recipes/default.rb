#
# Cookbook Name:: base-packages
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
include_recipe 'base-packages::motd'

node['base']['packages'].each do |pkg|
  apt_package pkg do
    action :install
  end
end

node['base']['sad_packages'].each do |sad_pkg|
  apt_package sad_pkg do
    action :purge
  end
end

require 'resolv'
hostname = `hostname`.chomp
ip = Resolv.getaddress(hostname)

cookbook_file node['base']['apt_file'] do
  source node['base']['apt_sources']
  owner node['base']['root_user']
  group node['base']['root_group']
  mode 0644
  notifies :run, "execute[apt-get-update]", :immediately
end

node['base']['dirs'].each do |dir|
  directory dir do
    action :create
  end
end

node['base']['files'].each do |file,source|
  cookbook_file "#{file}" do
    action :create
    source "#{source}"
    mode 0755
    owner node['base']['root_user']
    group node['base']['root_group']
  end
end

# I really need to get the key set up for this
node['base']['example_packages'].each do |pkg|
  apt_package pkg do
    action :install
    options "--force-yes -o Dpkg::Options::='--force-confnew'"
  end
end

node['base']['notify_only_execs'].each do |name,command|
  execute  "#{name}" do
    command "#{command}"
    user node['base']['root_user']
    group node['base']['root_group']
    action :nothing
  end
end

# running once by cron saves a shit-ton of memory. gg
node['base']['disabled_services'].each do |name|
  service name do
    action :disable
  end
end

directory node['base']['tmp_dir'] do
  action :create
  user node['base']['root_user']
  group node['base']['root_group']
  mode 0777
end
