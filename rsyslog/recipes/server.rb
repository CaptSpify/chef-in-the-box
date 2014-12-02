#
# Cookbook Name:: rsyslog
# Recipe:: server
#
# Copyright 2009-2013, Opscode, Inc.
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

# Manually set this attribute
node.set['rsyslog']['server'] = true

include_recipe 'rsyslog::default'
include_recipe 'rsyslog::syslog-emails'

pkgs_to_install= %w{ mutt }

pkgs_to_install.each do |pkg|
  apt_package pkg do
    action :install
  end
end


directory "/var/log/rsyslog/filtered" do
  owner    'syslog'
  group    'syslog'
  mode     '0755'
  recursive true
end

directory node['rsyslog']['log_dir'] do
  owner    'syslog'
  group    'syslog'
  mode     '0755'
  recursive true
end

template "#{node['rsyslog']['config_prefix']}/rsyslog.d/35-server-per-host.conf" do
  source   '35-server-per-host.conf.erb'
  owner    'syslog'
  group    'syslog'
  mode     '0644'
  notifies :restart, "service[#{node['rsyslog']['service_name']}]"
end

file "#{node['rsyslog']['config_prefix']}/rsyslog.d/remote.conf" do
  action   :delete
  notifies :reload, "service[#{node['rsyslog']['service_name']}]"
  only_if  { ::File.exists?("#{node['rsyslog']['config_prefix']}/rsyslog.d/remote.conf") }
end

# For some reason these file permissions get fucked
file "#{node['rsyslog']['default_log_dir']}/syslog" do
  mode      '0660'
  owner     'syslog'
  group     'syslog'
end

file "#{node['rsyslog']['default_log_dir']}/kern.log" do
  mode      '0660'
  owner     'syslog'
  group     'syslog'
end

file "#{node['rsyslog']['default_log_dir']}/mail.err" do
  mode      '0660'
  owner     'syslog'
  group     'syslog'
end

file "#{node['rsyslog']['default_log_dir']}/mail.info" do
  mode      '0660'
  owner     'syslog'
  group     'syslog'
end

file "#{node['rsyslog']['default_log_dir']}/mail.log" do
  mode      '0660'
  owner     'syslog'
  group     'syslog'
end

file "#{node['rsyslog']['default_log_dir']}/mail.warn" do
  mode      '0660'
  owner     'syslog'
  group     'syslog'
end

file "#{node['rsyslog']['default_log_dir']}/messages" do
  mode      '0660'
  owner     'syslog'
  group     'syslog'
end

file "#{node['rsyslog']['default_log_dir']}/user.log" do
  mode      '0660'
  owner     'syslog'
  group     'syslog'
end

file "#{node['rsyslog']['default_log_dir']}/auth.log" do
  mode      '0660'
  owner     'syslog'
  group     'syslog'
end
