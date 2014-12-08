#
# Cookbook Name:: users
# Recipe:: chefs
#
# Copyright 2011, Eric G. Wolfe
# Copyright 2009-2011, Opscode, Inc.
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

# Searches data bag "users" for groups attribute "chef".
# Places returned users in Unix group "chef" with GID 2300.

# fixes CHEF-1699
ruby_block "reset group list" do
  block do
    Etc.endgrent
  end
  action :nothing
end

# manage raspberry pi users
group "input" do
  gid 998
end

group "spi" do
  gid 1006
end

group "gpio" do
  gid 1007
end

# Fuck you raspberry pi
group "indiecity" do
  action :remove
end

# Delete users with the attribute active=false
search(:users, 'active:false') do |u|
  user u['id'] do
    action :remove
    supports :manage_home => false
  end
end

users_manage "www-data" do
  group_id 33
  action [ :remove, :create ]
end

users_manage "chef" do
  group_id 1004
  action [ :remove, :create ]
end

users_manage "repo" do
  group_id 800
  action [ :remove, :create ]
end

users_manage "users" do
  group_id 100
  action [ :remove, :create ]
end

users_manage "poopuser" do
  group_id 1000
  action [ :remove, :create ]
end

# Create users with the attribute active=true
search(:users, 'active:true') do |u|
  home_dir = "/home/#{u['id']}"
  # Create the user
  user u['id'] do
    uid u['uid']
    gid u['gid']
    shell u['shell']
    comment "User - #{u['comment']}"
    supports :manage_home => true
    home home_dir
    #notifies :create, "ruby_block[reset group list]", :immediately
    # Implement the hack to fix the group bug.
    notifies :create, resources(:ruby_block => "reset group list"), :immediately
  end
  # Create the user's homedir
  directory "#{home_dir}/.ssh" do
    owner u['id']
    group u['gid'] || u['id']
    mode "0700"
  end
  # Deploy the user's ssh public key
  template "#{home_dir}/.ssh/authorized_keys" do
    source "authorized_keys.erb"
    owner u['id']
    group u['gid'] || u['id']
    mode "0600"
    variables :ssh_keys => u['ssh_keys']
  end
end
