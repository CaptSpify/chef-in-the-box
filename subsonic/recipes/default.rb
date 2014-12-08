#
# Cookbook Name:: subsonic
# Recipe:: default
#

pkgs = value_for_platform(
  [ "centos", "redhat", "fedora" ] => {
    "default" => %w{ openjdk-6-jre ffmpeg }
  },
  [ "debian", "ubuntu" ] => {
    "default" => %w{ openjdk-6-jre ffmpeg }
  },
  "default" => %w{ openjdk-6-jre ffmpeg }
)
  
pkgs.each do |pkg|
  apt_package pkg do
    action :install
  end
end

# I don't remember what this is at all. I hope it works out well for you. Good luck here
# Install subsonic by hand
execute "if [[ \"$(dpkg --list subsonic | grep subsonic | awk '{print $2;}')\" != \"subsonic\" ]]; then curl --header 'Host: softlayer-dal.dl.sourceforge.net' --header 'User-Agent: Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:23.0) Gecko/20100101 Firefox/23.0' --header 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8' --header 'Accept-Language: en-US,en;q=0.5' --header 'DNT: 1' --header 'Referer: http://sourceforge.net/projects/subsonic/files/subsonic/4.8/subsonic-4.8.deb/download?use_mirror=softlayer-dal' --header 'Cookie: __utma=191645736.1375851055.1374111301.1374553527.1379128335.3; __utmz=191645736.1379128335.3.3.utmcsr=subsonic.org|utmccn=(referral)|utmcmd=referral|utmcct=/pages/download2.jsp; __utmb=191645736.3.9.1379128335; __utmc=191645736' --header 'Connection: keep-alive' 'http://softlayer-dal.dl.sourceforge.net/project/subsonic/subsonic/4.8/subsonic-4.8.deb' -o 'subsonic-4.8.deb' -L && dpkg --install subsonic-4.8.deb; fi"

user "subsonic" do
  comment "subsonic user"
  system true
  shell "/bin/false"
end

link "/etc/subsonic.conf" do
  to "/etc/default/subsonic"
  link_type :symbolic
end

link "/var/log/subsonic.log" do
  to "/var/subsonic/subsonic.log"
  link_type :symbolic
end

link "/var/log/subsonic_sh.log" do
  to "/var/subsonic/subsonic_sh.log"
  link_type :symbolic
end

service "subsonic" do 
  supports :status => true, :reload => true, :restart => true
  action [ :enable ]
end

template "/etc/default/subsonic" do
  source "subsonic.erb"
  variables( 
    :subsonic_user => node['subsonic']['subsonic_user'],
    :max_memory => node['subsonic']['max_memory'],
    :home => node['subsonic']['home'],
    :host => node['subsonic']['host'],
    :port => node['subsonic']['port'],
    :https_port => node['subsonic']['https_port'],
    :context_path => node['subsonic']['context_path'],
    :pid_file => node['subsonic']['pid_file'],
    :default_music_folder => node['subsonic']['default_music_folder'],
    :default_podcast_folder => node['subsonic']['default_podcast_folder'],
    :default_playlist_folder => node['subsonic']['default_playlist_folder']
  )
    notifies :restart, resources(:service => "subsonic")
end
