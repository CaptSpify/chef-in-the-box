#
# Cookbook Name:: chef
# Recipe:: default
#

service "couchdb" do
  service_name "couchdb"
  restart_command "/etc/init.d/couchdb restart && sleep 1"
  supports "default" => [ :restart, :reload, :status ]
  action :enable
end

directory "/var/log/couchdb" do
  owner "couchdb"
  group "couchdb"
  mode '0755'
end

template "/etc/default/couchdb" do
  source "couchdb.erb"
  owner "couchdb"
  group "couchdb"
  mode 00744
  notifies :restart, resources(:service => "couchdb")
  variables(
    :user => node['chef']['couchdb']['user'],
    :log_file => node['chef']['couchdb']['log_file'],
    :err_file => node['chef']['couchdb']['err_file'],
    :respawn_timeout => node['chef']['couchdb']['respawn_timeout'],
    :options => node['chef']['couchdb']['options']
  )
end
