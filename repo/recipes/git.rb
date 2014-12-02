#
# Cookbook Name:: repo
# Recipe:: default
#
#

pkgs = %w{ git }

pkgs.each do |pkg|
  apt_package pkg do
    action :install
  end
end

user "repo" do
  comment "repository"
  system true
  shell "/bin/bash"
  home "/var/repo/packages/gitdir"
end

directory "/var/repo/git" do
  action :create
  mode "0775"
  owner "repo"
  group "repo"
end

directory "/var/git" do
  owner "root"
  group "www-data"
  recursive(true)
end
