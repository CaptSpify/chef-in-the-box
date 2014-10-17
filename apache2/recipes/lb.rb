#
# Cookbook Name:: apache2
# Recipe:: lb
#
# I haven't actually tested this, as it's been depreciated to haproxy

packages = node['apache']['packages']

packages.each do |package|
  apt_package package do
    action :install
    options "-o Dpkg::Options::='--force-confnew'"
  end
end

service node['apache']['service'] do
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

node['apache']['files'].each do |file,source|
  cookbook_file "#{file}" do
    action :create
    source "#{source}"
    mode 0755
    owner node['ampache']['root_user']
    group node['ampache']['root_group']
    notifies :restart, resources(:service => node['ampache']['service'])
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
  end
end

# enable mod_deflate for consistency across distributions
include_recipe "apache2::mod_deflate"

file "#{node['apache']['dir']}/sites-enabled/000-default" do
  action :delete
end

template "apache2.conf" do
  path "#{node['apache']['dir']}/apache2.conf"
  source "apache2.conf.erb"
  group node['apache']['root_user']
  group node['apache']['root_group']
  mode 0644
  notifies :reload, resources(:service => "apache2")
end

template "lb-vhosts" do
  path "#{node['apache']['dir']}/sites-available/lb-vhosts"
  source "lb-vhost.erb"
  group node['apache']['root_user']
  group node['apache']['root_group']
  mode 0644
  variables(
  # This should really be more dynamic
    :domain => search(:node, "domain:#{zone['autodomain']}"),
    :http_subs => node["apache"]["http_subdomains"],
    :https_subs => node["apache"]["https_subdomains"],
    :serveradmin => search(:node, "domain:#{zone['contact']}")
  )
  notifies :reload, resources(:service => "apache2")
end

node['apache']['files'].each do |file,source|
  cookbook_file "#{file}" do
    action :create
    source "#{source}"
    mode 0750
    owner node['ampache']['user']
    group node['ampache']['group']
    notifies :restart, resources(:service => node['apache']['service'])
  end
end

template "security" do
  path "#{node['apache']['dir']}/conf.d/security"
  source "security.erb"
  owner node['apache']['root_user']
  group node['apache']['root_group']
  mode 0644
  notifies :reload, resources(:service => "apache2")
end

template "charset" do
  path "#{node['apache']['dir']}/conf.d/charset"
  source "charset.erb"
  owner node['apache']['root_user']
  group node['apache']['root_group']
  mode 0644
  notifies :reload, resources(:service => "apache2")
end

template "#{node['apache']['dir']}/ports.conf" do
  source "ports.conf.erb"
  owner node['apache']['root_user']
  group node['apache']['root_group']
  variables :apache_listen_ports => node['apache']['listen_ports'].map{|p| p.to_i}.uniq
  mode 0644
  notifies :reload, resources(:service => "apache2")
end

node['apache']['modules'].each do |apache_module|
  apache_module apache_module
end

node['apache']['sites'].each do |site|
  apache_site site
end

node['apache']['default_modules'].each do |mod|
  recipe_name = mod =~ /^mod_/ ? mod : "mod_#{mod}"
  include_recipe "apache2::#{recipe_name}"
end
