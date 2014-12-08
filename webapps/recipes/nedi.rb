#
# Cookbook Name:: nedi
# Recipe:: nedi
#
#

directory node['nedi']['log_dir'] do
  mode 0750
  owner node['nedi']['apache_username']
  group node['nedi']['apache_group']
  action :create
end

directory "#{node['nedi']['file_dir']}" do
  mode 0750
  recursive true
  owner node['nedi']['apache_username']
  group node['nedi']['apache_group']
  action :create
end

file "#{node['nedi']['log_dir']}/#{node['nedi']['log_file']}" do
  action :create
  mode 0750
  owner node['nedi']['apache_username']
  group node['nedi']['apache_group']
end

directory "/var/log/nedi" do
  mode 0750
  recursive true
  owner node['nedi']['apache_username']
  group node['nedi']['apache_group']
  action :create
end

cookbook_file "/var/nedi/nedi-update.sh" do
  source "nedi-update.sh"
  mode 0750
  owner node['nedi']['apache_username']
  group node['nedi']['apache_group']
end

cookbook_file "#{node['nedi']['file_dir']}/nedi.tgz" do
  source "nedi-1.0.9.tgz"
  mode 0750
  owner node['nedi']['apache_username']
  group node['nedi']['apache_group']
end

execute "if [ ! -e '/var/nedi/html' ]; then cd /var/nedi/ && tar -xzf #{node['nedi']['file_dir']}/nedi.tgz; chown -R www-data /var/nedi; fi"

template "#{node['nedi']['file_dir']}/#{node['nedi']['conf_file']}" do
  source "nedi.erb"
  owner node['nedi']['apache_username']
  group node['nedi']['apache_group']
  mode 0640
  action :create
end

template "#{node['apache']['dir']}/sites-available/nedi" do
  source "nedi/apache.erb"
  owner "root"
  group node['apache']['root_group']
  mode 0644
  notifies :reload, resources(:service => "apache2")
end
apache_site "nedi"
