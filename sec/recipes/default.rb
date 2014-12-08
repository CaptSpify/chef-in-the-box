#
# Cookbook Name:: sec
# Recipe:: default
#
#

# yeah yeah yeah. A case-statement of one. The most useless of poops
package "sec" do
	case node[:platform]
    when "debian"
      package_name "sec"
    end
	action :install
end

directory "/etc/sec/" do
  owner node[:sec][:user]
  group node[:sec][:user]
  mode 0755
end

service "sec" do
	case node[:platform]
    when "sec"
      service_name "sec"
    end
	supports :start => true, :stop => true, :restart => true, :"force-reload" => true
	action [ :enable ]
end

template "/etc/default/sec" do
	source "daemon_config.erb"
	owner "root"
	group "root"
	mode 0644
end

cookbook_file "#{node[:sec][:rules_file]}" do
	source "rules"
	owner "root"
	group "root"
	mode 0644
end

service "sec" do
	action [ :restart ]
end
