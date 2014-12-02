#
# Cookbook Name:: repo
# Recipe:: default
#
#

pkgs = %w{ reprepro build-essential autoconf automake autotools-dev libevent-dev libncurses5-dev checkinstall libglib2.0-dev libmpdclient-dev libmpdclient2 libcurl3 libcurl-ocaml libcurl4-gnutls-dev libwrap0-dev libwildmidi-dev libwavpack-dev libvorbis-dev libopenal-dev libid3tag0-dev libsqlite3-dev libresample1-dev libyajl-dev libcdio-paranoia-dev libbz2-dev libshout3-dev libmpg123-dev libmodplug-dev libopus-dev libsndfile1-dev libmpcdec-dev libvorbis-dev libdisplaymigration0-dev libvorbisenc2 libtwolame-dev libsoundgen-dev libroar-dev libjack-dev libao-dev libopenal-dev libavformat-dev libvalhalla-dev libavcodec-dev libavutil-dev libsidplay2-dev libmp3lame-dev libresample1-dev libsamplerate0-dev libssl-dev libssl-ocaml-dev gcc g++ git-core make patch libmysql++-dev cmake libghc-ncurses-dev libcurses-ocaml-dev ncurses-bin ncurses-base libtag1-dev }

pkgs.each do |pkg|
  apt_package pkg do
    action :install
  end
end

service "apache2" do
  case node['platform']
  when "redhat","centos","scientific","fedora","suse","amazon"
    service_name "httpd"
    # If restarted/reloaded too quickly httpd has a habit of failing.
    # This may happen with multiple recipes notifying apache to restart - like
    # during the initial bootstrap.
    restart_command "/sbin/service httpd restart && sleep 1"
    reload_command "/sbin/service httpd reload && sleep 1"
  when "debian","ubuntu"
    service_name "apache2"
    restart_command "/usr/sbin/invoke-rc.d apache2 restart && sleep 1"
    reload_command "/usr/sbin/invoke-rc.d apache2 reload && sleep 1"
  when "arch"
    service_name "httpd"
  when "freebsd"
    service_name "apache22"
  end
  supports value_for_platform(
    "debian" => { "4.0" => [ :restart, :reload ], "default" => [ :restart, :reload, :status ] },
    "ubuntu" => { "default" => [ :restart, :reload, :status ] },
    "redhat" => { "default" => [ :restart, :reload, :status ] },
    "centos" => { "default" => [ :restart, :reload, :status ] },
    "scientific" => { "default" => [ :restart, :reload, :status ] },
    "fedora" => { "default" => [ :restart, :reload, :status ] },
    "arch" => { "default" => [ :restart, :reload, :status ] },
    "suse" => { "default" => [ :restart, :reload, :status ] },
    "freebsd" => { "default" => [ :restart, :reload, :status ] },
    "amazon" => { "default" => [ :restart, :reload, :status ] },
    "default" => { "default" => [:restart, :reload ] }
  )
  action :enable
end

user "repoman" do
  comment "repository"
  system true
  shell "/bin/bash"
  home "/home/repoman"
end

directory "/var/www" do
  action :create
  mode "0664"
  owner "repomanman"
  group "www-data"
end

directory "/var/packages" do
  action :create
  mode "0775"
  owner "repoman"
  group "repoman"
end

directory "/var/packages/debian" do
  action :create
  mode "0775"
  owner "repoman"
  group "repoman"
end

directory "/var/packages/debian/conf" do
  action :create
  mode "0775"
  owner "repoman"
  group "repoman"
end

cookbook_file "/var/packages/debian/conf/distributions" do
  source "distributions"
  mode "0775"
  owner "repoman"
  group "repoman"
end

directory "/var/packages/debian/.gnupg" do
  action :create
  mode "0700"
  owner "repoman"
  group "repoman"
end

cookbook_file "/var/packages/debian/.gnupg/gpg.conf" do
  source "gpg.conf"
  mode "0700"
  owner "repoman"
  group "repoman"
end

cookbook_file "/var/packages/debian/.gnupg/pubring.gpg" do
  source "pubring.gpg"
  mode "0700"
  owner "repoman"
  group "repoman"
end

cookbook_file "/var/packages/debian/.gnupg/random_seed" do
  source "random_seed"
  mode "0700"
  owner "repoman"
  group "repoman"
end

cookbook_file "/var/packages/debian/.gnupg/secring.gpg" do
  source "secring.gpg"
  mode "0700"
  owner "repoman"
  group "repoman"
end

cookbook_file "/var/packages/debian/.gnupg/trustdb.gpg" do
  source "trustdb.gpg"
  mode "0700"
  owner "repoman"
  group "repoman"
end

cookbook_file "/var/packages/client.rb" do
  source "client.rb"
  mode "0744"
  owner "repoman"
  group "repoman"
end

cookbook_file "/var/packages/chef-setup.sh" do
  source "chef-setup.sh"
  mode "0744"
  owner "repoman"
  group "repoman"
end

directory "/usr/local/share/doc" do
  mode "0755"
  owner "root"
  group "root"
  action :create
end

service "apache2" do
  action :start
end

cookbook_file "/etc/cron.d/repo.backup" do
  source "repo.backup.cron"
  mode "0744"
  owner "root"
  group "root"
end

