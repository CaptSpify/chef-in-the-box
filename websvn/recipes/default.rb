#
# Cookbook Name:: websvn
# Recipe:: default
#

packages = case node[:platform]
  when "debian"
    %w{apache2 websvn}
  else
    %w{apache2 websvn}
  end
  
packages.each do |pkg|
  apt_package pkg do
    action :install
    options "-o Dpkg::Options::='--force-confnew'"
  end
end

service "apache2" do
  service_name "apache2"
  restart_command "/usr/sbin/invoke-rc.d apache2 restart && sleep 1"
  reload_command "/usr/sbin/invoke-rc.d apache2 reload && sleep 1"
  action :enable
end

directory "/etc/websvn" do
  owner "www-data"
  group "www-data"
  mode "0755"
end

template "/etc/apache2/sites-available/websvn" do
  source "websvn.conf.erb"
  variables( 
    :alias => "#{node['websvn']['alias']}",
    :directory => "#{node['websvn']['directory']}",
    :directory_index => "#{node['websvn']['directory_index']}"
  )
  owner "root"
  group "root"
  mode 0644
end

template "/etc/websvn/svn_deb_conf.inc" do
  source "svn_deb_conf.inc.erb"
  variables( 
    :parent_path=> "#{node['websvn']['parent_path']}",
    :enscript_path => "#{node['websvn']['enscript_path']}",
    :sed_path => "#{node['websvn']['sed_path']}"
  )
  owner "www-data"
  group "www-data"
end

cookbook_file "/var/www/healthcheck.txt" do
  source "healthcheck.txt"
  mode 0744
end

cookbook_file "/usr/share/websvn/healthcheck.txt" do
  source "healthcheck.txt"
  mode 0744
end

cookbook_file "/usr/share/websvn/.htaccess" do
  source "htaccess"
  mode 0744
end

template "/etc/apache2/.htwebsvn" do
  source "htwebsvn"
  mode 0744
end

template "/etc/apache2/ports.conf" do
  source "ports.conf.erb"
  variables :websvn_listen_ports => node['websvn']['listen_ports'].map{|p| p.to_i}.uniq
  notifies :restart, resources(:service => "apache2")
end
