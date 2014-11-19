#
# Cookbook Name:: netcfg
# Recipe:: default
#

service "networking" do
  supports :restart => true
  action [:start, :enable]
end

apt_package "resolvconf" do
  action :purge
end

require 'resolv'
hostname = `hostname`.chomp
ip = Resolv.getaddress(hostname)

search(:zones, 'domain:*').each do |zone|
  # We need to have special iterfaces for xen
  # yes there are better ways to do this, but here's why I chose this way: http://i.imgur.com/IE6gisg.gif
  if hostname.include? "ganeti"
    template "/etc/network/interfaces" do
      source "interfaces.erb"
      variables( 
      :INTERFACE => "xen-br0", 
      :IP => "static", 
      :ADDR => ip, 
      :NETMASK => "255.255.255.0", 
      :NETWORK => "10.0.0.0", 
      :GATEWAY => "10.0.0.254",
      :BRIDGE_PORTS => "eth0",
      :BRIDGE_STP => "off",
      :BRIDGE_FD => "0",
      :OFFLOAD => "off",
      :NAMESERVER => zone['zone_info']['nameserver']
      )
      notifies :restart, resources(:service => "networking")
    end
  else
    template "/etc/network/interfaces" do
      source "interfaces.erb"
      variables( 
      :INTERFACE => "eth0", 
      :IP => "static", 
      :ADDR => ip, 
      :NETMASK => "255.255.255.0", 
      :NETWORK => "10.0.0.0", 
      :GATEWAY => "10.0.0.254",
      :NAMESERVER => zone['zone_info']['nameserver']
      )
      notifies :restart, resources(:service => "networking")
    end
  end

  template "/etc/resolv.conf" do
    source "resolv.conf.erb"
    mode 0644
    variables(
    # This should really be more dynamic
      :domain => "example.com", 
      :nameserver => zone['zone_info']['nameserver']
    )
  end
end
