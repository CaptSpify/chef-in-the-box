# encoding: utf-8
# Copyright:: Copyright (c) 2012, Opscode, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

include_recipe 'postfix'

directory "/etc/postfix" do 
  mode 0775
  owner "root"
  group "postfix"
end

execute 'update-postfix-aliases' do
  command 'newaliases'
  action :nothing
end

template node['postfix']['aliases_db'] do
  source 'aliases.erb'
  mode '0600'
  owner 'root'
  group 'root'
  notifies :run, 'execute[update-postfix-aliases]'
end

template node['postfix']['virtual_mailbox_map_file'] do
  source 'virtual.erb'
  mode '0644'
  owner 'postfix'
  group 'postfix'
end

execute 'update-virtual-aliases' do
  command "postmap #{node['postfix']['virtual_mailbox_map_file']}"
  action :run
end

template node['postfix']['virtual_uid_map_file'] do
  source 'map_file.erb'
  mode '0644'
  owner 'postfix'
  group 'postfix'
end

execute 'update-virtual-uid' do
  command "postmap #{node['postfix']['virtual_uid_map_file']}"
  action :run
end

template node['postfix']['virtual_gid_map_file'] do
  source 'map_file.erb'
  mode '0644'
  owner 'postfix'
  group 'postfix'
end

execute 'update-virtual-uid' do
  command "postmap #{node['postfix']['virtual_gid_map_file']}"
  action :run
end
