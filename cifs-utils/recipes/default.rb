#
# Cookbook Name:: cifs-utils
# Recipe:: default
#
# I have no idea why I made this it's own cookbook, but I'm sure it's a *very* good reason......
#

packages = case node[:platform]
  when "debian"
    %w{cifs-utils}
  else
    %w{cifs-utils}
  end
  
packages.each do |pkg|
  package pkg
end
