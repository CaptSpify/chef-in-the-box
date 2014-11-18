#
# Cookbook Name:: dnsutils
# Recipe:: default
# Why did I make this it's own cookbook? I dunno
#

packages = case node[:platform]
  when "debian"
    %w{dnsutils}
  else
    %w{dnsutils}
  end
  
packages.each do |pkg|
  package pkg
end
