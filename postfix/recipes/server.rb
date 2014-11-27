# encoding: utf-8
#
# Author:: Joshua Timberman(<joshua@opscode.com>)
# Cookbook Name:: postfix
# Recipe:: server
#
# Copyright 2009-2012, Opscode, Inc.
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

pkgs = %w{ libsasl2-modules postfix sasl2-bin }
  
pkgs.each do |pkg|
  apt_package pkg do
    action :install
  end
end

node.override['postfix']['mail_type'] = 'master'
node.override['postfix']['main']['inet_interfaces'] = 'all'

include_recipe 'postfix'

directory "/var/mail" do 
  mode 01600
  owner "root"
  group "mail"
end

cookbook_file "/etc/ssl/certs/example.pem" do 
  source "example.pem"
  mode 700
  owner "root"
  group "root"
end

cookbook_file "/etc/ssl/private/example.key" do 
  source "example.key"
  mode 740
  owner "root"
  group "ssl-cert"
end

bash "newaliases" do 
  code <<-EOF
    newaliases
  EOF
end

template "/etc/postfix/sasl/smtpd.conf" do
  source "smtpd.conf.erb"
  mode 0700
  owner "root"
  group "root"
end

user "user1" do
  supports :non_unique => true
  uid 1000
  gid 1000
  home "/home/user1"
  action :create
end

group "sasl" do
  action :modify
  members "postfix"
  append true
end

group "mail" do
  action :modify
  members "user1"
  append true
end
