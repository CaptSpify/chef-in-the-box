#
# Cookbook Name:: webapps
# Recipe:: default
#
#

# Chef "always" runs cookbooks in the orer listed. Except when it doesn't. *rolls eyes*
include_recipe "users"

pkgs = value_for_platform(
  [ "centos", "redhat", "fedora" ] => {
    "default" => %w{ php5-gd imagemagick ffmpeg apache2-mpm-prefork libapache2-mod-php5 git }
  },
  [ "debian", "ubuntu" ] => {
    "default" => %w{ php5-gd imagemagick ffmpeg apache2-mpm-prefork libapache2-mod-php5 git }
  },
  "default" => %w{ php5-gd imagemagick ffmpeg apache2-mpm-prefork libapache2-mod-php5 git }
)
 
pkgs.each do |pkg|
  apt_package pkg do
    action :install
  end
end

template "/root/git-pull-perms.sh" do
  source "git-pull-perms.sh"
  owner "root"
  group "root"
  mode 0700
end

cookbook_file "/etc/cron.d/package-compare" do
  source "package.compare.cron"
  owner "root"
  group "root"
  mode 0755
end

file "/etc/cron.d/www-pull" do
  action :delete
end

cookbook_file "/usr/bin/package.compare.sh" do
  owner "root"
  group "root"
  mode 0755
end

template "/etc/cron.d/tmp-cleanup" do
  source "tmp-cleanup"
  owner "root"
  group "root"
  mode 0700
end

link "/var/wwww/packages" do
  to "/var/wwww"
  owner "www-data"
  group "www-data"
  link_type :symbolic
end

directory "/var/wwww/code" do
  owner "www-data"
  group "www-data"
  recursive(true)
end

directory "/var/wwww/pictures" do
  owner "www-data"
  group "www-data"
  recursive(true)
end

directory "/var/wwww/blog" do
  owner "www-data"
  group "www-data"
  recursive(true)
end

directory "/var/www" do
  owner "www-data"
  group "www-data"
  recursive(true)
end

# I don't know if the defuault it used/needed, but I don't want to investigate right now
template "#{node['apache']['dir']}/sites-available/default" do
  source "default-site.erb"
  owner "root"
  group node['apache']['root_group']
  mode 0644
  notifies :reload, resources(:service => "apache2")
end
apache_site "default"

template "#{node['apache']['dir']}/sites-available/code" do
  source "code.erb"
  owner "root"
  group node['apache']['root_group']
  mode 0644
  notifies :reload, resources(:service => "apache2")
end
apache_site "code"

template "#{node['apache']['dir']}/sites-available/blog" do
  source "blog.erb"
  owner "root"
  group node['apache']['root_group']
  mode 0644
  notifies :reload, resources(:service => "apache2")
end
apache_site "blog"

apache_module "php5"
