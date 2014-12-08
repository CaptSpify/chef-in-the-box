#
# Cookbook Name:: upload
# Recipe:: upload
#
#

directory node['upload']['log_dir'] do
  mode 0750
  owner node['upload']['apache_username']
  group node['upload']['apache_group']
  action :create
end

directory "#{node['upload']['file_dir']}" do
  mode 0750
  owner node['upload']['apache_username']
  group node['upload']['apache_group']
  action :create
end

%w{hour day week month}.each do |dir|
  directory "#{node['upload']['file_dir']}#{dir}" do
    mode 0750
    owner node['upload']['apache_username']
    group node['upload']['apache_group']
    action :create
  end
end

%w{hour day week month}.each do |dir|
  template "#{node['upload']['file_dir']}#{dir}/.htaccess" do
    source "upload/subfolder.htaccess.erb"
    mode 0750
    owner node['upload']['apache_username']
    group node['upload']['apache_group']
    action :create
  end
end

file "#{node['upload']['log_dir']}/#{node['upload']['log_file']}" do
  action :create
  mode 0750
  owner node['upload']['apache_username']
  group node['upload']['apache_group']
end

template "#{node['upload']['apache_dir']}/upload.htpasswd" do
  source "upload/upload.htpasswd.erb"
  mode 0755
  owner node['upload']['apache_username']
  group node['upload']['apache_group']
  action :create
end

template "#{node['upload']['file_dir']}/.htaccess" do
  source "upload/htaccess.erb"
  mode 0755
  owner node['upload']['apache_username']
  group node['upload']['apache_group']
  action :create
end

template "#{node['upload']['file_dir']}/index.php" do
  source "upload/index.php.erb"
  owner node['upload']['apache_username']
  group node['upload']['apache_group']
  mode 0640
  action :create
end

template "#{node['upload']['file_dir']}/upload.php" do
  source "upload/upload.php.erb"
  owner node['upload']['apache_username']
  group node['upload']['apache_group']
  mode 0640
  action :create
  notifies :reload, "service[apache2]"
end

template "#{node['apache']['dir']}/sites-available/tmp" do
  source "tmp.erb"
  owner "root"
  group node['apache']['root_group']
  mode 0644
  notifies :reload, resources(:service => "apache2")
end
apache_site "tmp"
