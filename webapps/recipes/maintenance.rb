#
# Cookbook Name:: ampache
# Recipe:: maintenance
#

cookbook_file "/etc/cron.d/ampache-maintenance" do
  source "ampache-maintenance"
  mode 0755
end 

