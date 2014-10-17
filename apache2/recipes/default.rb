#
# Cookbook Name:: apache2
# Recipe:: default
#
# Copyright 2008-2009, Opscode, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

node['apache']['packages'].each do |package|
  apt_package package do
    action :install
    options "-o Dpkg::Options::='--force-confnew'"
  end
end

service node['apache']['service'] do
  restart_command "/usr/sbin/invoke-rc.d apache2 restart && sleep 1"
  reload_command "/usr/sbin/invoke-rc.d apache2 reload && sleep 1"
  supports  :restart => true, :reload => true, :status => true
  action :enable
end

node['apache']['dirs'].each do |dir|
  directory "#{dir}" do
    action :create
    owner node['apache']['root_user']
    group node['apache']['root_group']
  end
end

template "apache2.conf" do
  path "#{node['apache']['dir']}/apache2.conf"
  source "apache2.conf.erb"
  owner node['apache']['root_user']
  group node['apache']['root_group']
  mode 0644
  notifies :reload, resources(:service => "apache2")
end

template "security" do
  path "#{node['apache']['dir']}/conf.d/security"
  source "security.erb"
  owner node['apache']['root_user']
  group node['apache']['root_group']
  mode 0644
  notifies :reload, resources(:service => "apache2")
end

template "charset" do
  path "#{node['apache']['dir']}/conf.d/charset"
  source "charset.erb"
  owner node['apache']['root_user']
  group node['apache']['root_group']
  mode 0644
  notifies :reload, resources(:service => "apache2")
end

template "#{node['apache']['dir']}/ports.conf" do
  source "ports.conf.erb"
  owner node['apache']['root_user']
  group node['apache']['root_group']
  variables :apache_listen_ports => node['apache']['listen_ports'].map{|p| p.to_i}.uniq
  mode 0644
  notifies :reload, resources(:service => "apache2")
end

node['apache']['default_modules'].each do |mod|
  recipe_name = mod =~ /^mod_/ ? mod : "mod_#{mod}"
  include_recipe "apache2::#{recipe_name}"
end

node['apache']['sites'].each do |site|
  apache_site site
end
