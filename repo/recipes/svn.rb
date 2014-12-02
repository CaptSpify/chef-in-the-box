#
# Cookbook Name:: repo
# Recipe:: default
#
#

pkgs = %w{ websvn subversion libsvn1 }

pkgs.each do |pkg|
  apt_package pkg do
    action :install
  end
end

user 'svn' do
  home '/var/repo/svn-server'
  system true
  shell '/bin/false'
  group "svn"
end

directory "/var/repo/svn-server" do
  owner "svn"
  group "svn"
  recursive(true)
end


# repo
directory "/var/repo/packages" do
  owner "repo"
  group "repo"
  action :create
end

directory "/var/repo/packages/debian" do
  owner "repo"
  group "repo"
  action :create
end

directory "/var/repo/packages/debian/conf" do
  owner "repo"
  group "repo"
  action :create
end
 
cookbook_file "/var/repo/packages/debian/conf/distributions" do
  source "distributions"
  mode 0755
  owner "repo"
  group "repo"
end

execute "if [ ! -e '/var/repo/packages/debian/db/checksums.db' ]; then /usr/bin/build.repo.sh; fi" do
  action :run
end
