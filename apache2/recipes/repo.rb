#
# Cookbook Name:: apache2
# Recipe:: repo
#

node['apache']['repo']['packages'].each do |pkg|
  apt_package pkg do
    action :install
    options "-o Dpkg::Options::='--force-confnew'"
  end
end

service node['apache']['repo']['service'] do
  restart_command "/usr/sbin/invoke-rc.d apache2 restart && sleep 1"
  reload_command "/usr/sbin/invoke-rc.d apache2 reload && sleep 1"
  supports  :restart => true, :reload => true, :status => true
  action :enable
end

directory node['apache']['log_dir'] do
  mode 0755
  owner node['apache']['user']
  group node['apache']['user']
  action :create
end

cookbook_file "/usr/local/bin/apache2_module_conf_generate.pl" do
  source "apache2_module_conf_generate.pl"
  mode 0750
  owner "root"
  group "root"
end

execute "generate-module-list" do
  command "/usr/local/bin/apache2_module_conf_generate.pl #{node['apache']['lib_dir']} #{node['apache']['dir']}/mods-available"
  action :run
end

node['apache']['dirs'].each do |dir|
  directory "#{dir}" do
    action :create
    mode 0755
    owner node['apache']['user']
    group node['apache']['group']
  end
end

execute "generate-module-list" do
  command "/usr/local/bin/apache2_module_conf_generate.pl #{node['apache']['lib_dir']} #{node['apache']['dir']}/mods-available"
  action :run
end

# installed by default on centos/rhel, remove in favour of mods-enabled
%w{ proxy_ajp auth_pam authz_ldap webalizer ssl welcome }.each do |f|
  file "#{node['apache']['dir']}/conf.d/#{f}.conf" do
    action :delete
    backup false
  end
end

# enable mod_deflate for consistency across distributions
include_recipe "apache2::mod_deflate"

file "#{node['apache']['dir']}/sites-enabled/000-default" do
  action :delete
end

search(:zones, 'domain:*').each do |zone|
  template "repo" do
    path "#{node['apache']['dir']}/sites-available/repo"
    source "repo.erb"
    owner node['apache']['root_user']
    group node['apache']['root_group']
    mode 0644
    variables(
    # This should really be more dynamic
      :domain => zone['zone_info']['autodomain'],
      :http_subs => node["apache"]["http_subdomains"],
      :https_subs => node["apache"]["https_subdomains"],
      :serveradmin => zone['zone_info']['contact']
    )
    notifies :reload, resources(:service => node['apache']['repo']['service'])
  end
end

node['apache']['files'].each do |file,source|
  cookbook_file "#{file}" do
    action :create
    source "#{source}"
    mode 0755
    owner node['apache']['root_user']
    group node['apache']['root_group']
    notifies :restart, resources(:service => node['apache']['repo']['service'])
  end
end

template "security" do
  path "#{node['apache']['dir']}/conf.d/security"
  source "security.erb"
  owner "root"
  group node['apache']['root_group']
  mode 0644
  backup false
  notifies :reload, resources(:service => node['apache']['repo']['service'])
end

template "charset" do
  path "#{node['apache']['dir']}/conf.d/charset"
  source "charset.erb"
  owner "root"
  group node['apache']['root_group']
  mode 0644
  backup false
  notifies :reload, resources(:service => node['apache']['repo']['service'])
end

node['apache']['repo']['default_modules'].each do |mod|
  recipe_name = mod =~ /^mod_/ ? mod : "mod_#{mod}"
  include_recipe "apache2::#{recipe_name}"
end

node['apache']['repo']['sites'].each do |site|
  apache_site site
end
