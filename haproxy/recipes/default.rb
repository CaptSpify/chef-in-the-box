#
# Cookbook Name:: haproxy
# Recipe:: default
#
# Copyright 2009, Opscode, Inc.
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

include_recipe "haproxy::install_#{node['haproxy']['install_method']}"

cookbook_file "/etc/default/haproxy" do
  source "haproxy-default"
  owner "root"
  group "root"
  mode 00644
  notifies :restart, "service[haproxy]"
end

cookbook_file "/etc/haproxy/example.key" do
  source "example.key"
  owner "root"
  group "root"
  mode 00644
  notifies :restart, "service[haproxy]"
end

cookbook_file "/etc/haproxy/example.pem" do
  source "example.pem"
  owner "root"
  group "root"
  mode 00644
  notifies :restart, "service[haproxy]"
end

cookbook_file "/etc/haproxy/example.crt" do
  source "example.crt"
  owner "root"
  group "root"
  mode 00644
  notifies :restart, "service[haproxy]"
end

if node['haproxy']['enable_admin']
  admin = node['haproxy']['admin']
  haproxy_lb "admin" do
    bind "#{admin['address_bind']}:#{admin['port']}"
    mode 'http'
    params({ 'stats' => 'uri /'})
  end
end

conf = node['haproxy']
member_max_conn = conf['member_max_connections']
member_weight = conf['member_weight']

#### default-http
haproxy_lb 'http' do
  type 'frontend'
  params([
  'bind *:80',
  'mode http',
  'maxconn 20000',
  'default_backend http',
  'reqadd X-Forwarded-Proto:\ http',
  'option forwardfor',
  'redirect scheme https if { hdr(Host) -i pic.example.com } !{ ssl_fc }',
  'redirect scheme https if { hdr(Host) -i blog.example.com } !{ ssl_fc }',
  'option httplog'
  ])
end

haproxy_lb 'http' do
  type 'backend'
  params([
  #kyel Should probably pull this dynamically from a role-search....
  'server web1 web1.example.com:80 cookie a check',
  'server web2 web2.example.com:80 cookie b check',
  'balance source',
  'option httpclose',
  'cookie JSESSIONID prefix',
  'option httpchk HEAD /healthcheck.txt',
  'option httplog'
  ])
end
#### default-http

#### default-https
haproxy_lb 'https' do
  type 'frontend'
  params([
  'bind *:443 ssl crt /etc/haproxy/example.pem',
  'mode http',
  'maxconn 20000',
  'default_backend https',
  'acl is_blog hdr_beg(host) -i blog',
  'use_backend blog if is_blog',
  'option forwardfor',
  'option httpclose',
  'option httplog'
  ])
end

haproxy_lb 'https' do
  type 'backend'
  params([
  #kyel Should probably pull this dynamically from a role-search....
  'server web1 web1.example.com:80 cookie a check',
  'server web2 web2.example.com:80 cookie b check',
  'balance source',
  'option httpclose',
  'cookie JSESSIONID prefix',
  'option httpchk HEAD /healthcheck.txt',
  'option httplog'
  ])
end
#### default-https

#### blog
haproxy_lb 'blog' do
  type 'backend'
  params([
  #kyel Should probably pull this dynamically from a role-search....
  'server blog1 web1.example.com:80 check',
  'server blog2 web2.example.com:80 check',
  'balance source',
  'mode http',
  'cookie JSESSIONID prefix',
  'option httpchk HEAD /healthcheck.txt',
  'option httplog'
  ])
end
#### blog

template "#{node['haproxy']['conf_dir']}/haproxy.cfg" do
  source "haproxy.cfg.erb"
  owner "root"
  group "root"
  mode 00644
  notifies :reload, "service[haproxy]"
  variables(
    :defaults_options => haproxy_defaults_options,
    :defaults_timeouts => haproxy_defaults_timeouts
  )
end

service "haproxy" do
  supports :restart => true, :status => true, :reload => true
  action [:enable, :start]
end
