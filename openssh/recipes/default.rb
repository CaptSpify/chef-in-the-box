#
# Cookbook Name:: openssh
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

packages = case node[:platform]
  when "centos","redhat","fedora"
    %w{openssh-clients openssh}
  when "arch"
    %w{openssh}
  else
    %w{openssh-client openssh-server}
  end
  
packages.each do |pkg|
  package pkg
end

template "/etc/ssh/sshd_config" do
  source "sshd_config.erb"
  variables(
    :Port => "22" # For som reason, this doesn't work using the template file. Probably because I'm potato-man
  )
end

service "ssh" do
case node[:platform]
when "centos","redhat","fedora","arch"
service_name "sshd"
else
service_name "ssh"
end
supports value_for_platform(
    "debian" => { "default" => [ :restart, :reload, :status ] },
    "ubuntu" => {
    "8.04" => [ :restart, :reload ],
    "default" => [ :restart, :reload, :status ]
    },
    "centos" => { "default" => [ :restart, :reload, :status ] },
    "redhat" => { "default" => [ :restart, :reload, :status ] },
    "fedora" => { "default" => [ :restart, :reload, :status ] },
    "arch" => { "default" => [ :restart ] },
    "default" => { "default" => [:restart, :reload ] }
    )
action [ :enable, :start ]
end

home_dir = "/home/user1" # -- Need to find a better way to do this. Works for me for now though |:D

directory "#{home_dir}/.ssh" do
  action :create
  owner "user1"
  group "user1"
  mode 0700
end

template "#{home_dir}/.ssh/config" do
  source "ssh_config.erb"
  owner "user1"
  group "user1"
  mode 0700
end

execute "ssh-keygen" do
  command "ssh-keygen -P '' -f #{home_dir}/.ssh/id_rsa"
  creates "#{home_dir}/.ssh/id_rsa"
  not_if "test -f #{home_dir}/.ssh/id_rsa"
  action :run
end
