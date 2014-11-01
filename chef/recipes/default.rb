#
# Cookbook Name:: chef
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
apt_packages = %w{chef-server-webui ruby-openid ruby-coderay chef-expander libgecode-dev chef chef-server-api }

apt_packages.each do |pkg|
  apt_package pkg do
    action :install
    options "--force-yes -o Dpkg::Options::='--force-confnew'"
  end
end

gem_packages = %w{chef-server chef-server-api chef-server chef-solr}

gem_packages.each do |pkg|
  gem_package pkg do
    action :install
  end
end

service "rabbitmq-server" do
  service_name "rabbitmq-server"
  supports :status => true, :restart => true
  action [ :enable, :start ]
end

service "chef-expander" do
  service_name "chef-expander"
  supports :status => true, :restart => true
  action [ :enable, :start ]
end

service "chef-server" do
  service_name "chef-server"
  supports :status => true, :restart => true
  action [ :enable, :start ]
end

service "chef-server-webui" do
  service_name "chef-server-webui"
  supports :status => true, :restart => true
  action [ :enable, :start ]
end

service "chef-solr" do
  service_name "chef-solr"
  supports :status => true, :restart => true
  action [ :enable, :start ]
end

execute 'rabbitmq-server-setup' do
  command 'if ! rabbitmqctl list_vhosts  | grep -i chef; then rabbitmqctl add_vhost /chef; rabbitmqctl add_user chef rabbitmqpasswordonlyacceptsplaintextwtf; rabbitmqctl set_permissions -p /chef chef ".*" ".*" ".*"; touch /etc/chef/rabbit.record; fi'
  action :run
end

execute 'rabbitmq-server-setup' do
  command 'rabbitmqctl change_password chef rabbitmqpasswordonlyacceptsplaintextwtf'
  action :run
end

cookbook_file "/etc/cron.d/rabbitmq-server" do
  source "rabbitmq-server-cron"
  owner "root"
  group "root"
  mode 00744
end

cookbook_file "/etc/cron.d/chef-backup" do
  source "chef-backup-cron"
  owner "root"
  group "root"
  mode 00744
end

cookbook_file "/usr/sbin/chef-backup" do
  source "chef-backup"
  owner "root"
  group "root"
  mode 00744
end

cookbook_file "/etc/chef/server.rb" do
  source "server.rb"
  owner "chef"
  group "root"
  mode 00744
  notifies :restart, resources(:service => "chef-server")
end

cookbook_file "/etc/chef/solr.rb" do
  source "solr.rb"
  owner "chef"
  group "root"
  mode 00744
  notifies :restart, resources(:service => "chef-solr")
end

directory "/var/lib/gems/1.9.1/gems/chef-expander-10.30.2" do
  action :create
  owner "root"
  group "root"
  mode 00744
end

directory "/var/lib/gems/1.9.1/gems/chef-10.30.2" do
  action :create
  owner "root"
  group "root"
  mode 00744
end

directory "/var/lib/gems/1.9.1/gems/chef-10.30.2/bin" do
  action :create
  owner "root"
  group "root"
  mode 00744
end

directory "/var/lib/gems/1.9.1/gems/chef-expander-10.30.2/lib" do
  action :create
  owner "root"
  group "root"
  mode 00744
end

directory "/var/lib/gems/1.9.1/gems/chef-expander-10.30.2/lib/chef" do
  action :create
  owner "root"
  group "root"
  mode 00744
end

directory "/var/lib/gems/1.9.1/gems/chef-expander-10.30.2/lib/chef/expander" do
  action :create
  owner "root"
  group "root"
  mode 00744
end

cookbook_file "/var/lib/gems/1.9.1/gems/chef-expander-10.30.2/lib/chef/expander/configuration.rb" do
  source "configuration.rb"
  owner "root"
  group "root"
  mode 00744
  notifies :restart, resources(:service => "chef-server")
end

cookbook_file "/etc/solr/conf/solrconfig.xml" do
  source "etc-solrconfig.xml"
  owner "chef"
  group "chef"
  mode 00644
  notifies :restart, resources(:service => "chef-solr")
end

cookbook_file "/var/lib/chef/solr/conf/solrconfig.xml" do
  source "lib-solrconfig.xml"
  owner "chef"
  group "chef"
  mode 00644
  notifies :restart, resources(:service => "chef-solr")
end

cookbook_file "/var/lib/gems/1.9.1/gems/chef-expander-10.30.2/lib/chef/expander.rb" do
  source "expander.rb"
  owner "root"
  group "root"
  mode 00744
  notifies :restart, resources(:service => "chef-server")
end

cookbook_file "/usr/local/bin/knife" do
  source "knife"
  owner "root"
  group "root"
  mode 00755
end

cookbook_file "/var/lib/gems/1.9.1/gems/chef-10.30.2/bin/knife" do
  source "knife"
  owner "root"
  group "root"
  mode 00755
end

directory "/home/user/.chef" do
  owner "user"
  group "user"
  mode 00700
end

cookbook_file "/home/user/.chef/knife.rb" do
  source "knife.rb"
  owner "user"
  group "user"
  mode 00700
end

directory "/var/log/chef" do
  owner "chef"
  group "root"
  mode 00744
end

file "/var/log/chef/server.log" do
  owner "chef"
  group "root"
  mode 00744
end

file "/etc/chef/webui.pem" do
  owner "chef"
  group "chef"
  mode 00750
end

file "/var/log/chef.log" do
  action :delete
end

cookbook_file "/etc/logrotate.d/chef-server-api" do
  source "chef-server-api.logrotate"
  owner "root"
  group "root"
  mode 0644
end

cookbook_file "/etc/logrotate.d/chef-server-webui" do
  source "chef-server-webui.logrotate"
  owner "root"
  group "root"
  mode 0644
end
