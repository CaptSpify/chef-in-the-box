#
# Cookbook Name:: ampache
# Recipe:: default
#

packages = node['ampache']['packages']
services = node['ampache']['service']['status']

packages.each do |pkg|
  apt_package "#{pkg}" do
    action :install
  end
end

service node['ampache']['service'] do 
  supports :status => true, :reload => true, :restart => true
  action [ :enable ]
end

node['ampache']['symlinks'].each do |link,file|
  link "#{link}" do
    to "#{file}"
  end
end

node['ampache']['dirs'].each do |dir|
  directory "#{dir}" do 
    action :create
    owner node['ampache']['user']
    group node['ampache']['group']
  end
end

node['ampache']['files'].each do |file,source|
  cookbook_file "#{file}" do
    action :create
    source "#{source}"
    mode 0755
    owner node['ampache']['user']
    group node['ampache']['group']
    notifies :restart, resources(:service => node['ampache']['service'])
  end
end

template "/usr/share/ampache/www/config/ampache.cfg.php" do
  source "ampache.cfg.php.erb"
  variables( 
    :default_playlist_folder => node['ampache']['default_playlist_folder'],
    :config_version => node['ampache']['config_version'],
    :web_path => node['ampache']['web_path'],
    :database_hostname => node['ampache']['database_hostname'],
    :database_name => node['ampache']['database_name'],
    :database_username => node['ampache']['database_username'],
    :database_password => node['ampache']['database_password'],
    :session_length => node['ampache']['session_length'],
    :stream_length => node['ampache']['stream_length'],
    :remember_length => node['ampache']['remember_length'],
    :session_name => node['ampache']['session_name'],
    :session_cookielife => node['ampache']['session_cookielife'],
    :session_cookiesecure => node['ampache']['session_cookiesecure'],
    :auth_methods => node['ampache']['auth_methods'],
    :catalog_file_pattern => node['ampache']['catalog_file_pattern'],
    :catalog_video_pattern => node['ampache']['catalog_video_pattern'],
    :catalog_prefix_pattern => node['ampache']['catalog_prefix_pattern'],
    :access_control => node['ampache']['access_control'],
    :require_session => node['ampache']['require_session'],
    :require_localnet_session => node['ampache']['require_localnet_session'],
    :track_user_ip => node['ampache']['track_user_ip'],
    :allow_zip_download => node['ampache']['allow_zip_download'],
    :file_zip_download => node['ampache']['file_zip_download'],
    :file_zip_path => node['ampache']['file_zip_path'],
    :tag_order => node['ampache']['tag_order'],
    :use_auth => node['ampache']['use_auth'],
    :default_auth_level => node['ampache']['default_auth_level'],
    :ratings => node['ampache']['ratings'],
    :shoutbox => node['ampache']['shoutbox'],
    :album_art_preferred_filename => node['ampache']['album_art_preferred_filename'],
    :album_art_order => node['ampache']['album_art_order'],
    :show_album_art => node['ampache']['show_album_art'],
    :amazon_base_urls => node['ampache']['amazon_base_urls'],
    :max_amazon_results_pages => node['ampache']['max_amazon_results_pages'],
    :debug => node['ampache']['debug'],
    :debug_level => node['ampache']['debug_level'],
    :site_charset => node['ampache']['site_charset'],
    :refresh_limit => node['ampache']['refresh_limit'],
    :allow_public_registration => node['ampache']['allow_public_registration'],
    :captcha_public_reg => node['ampache']['captcha_public_reg'],
    :mail_domain => node['ampache']['mail_domain'],
    :mail_from => node['ampache']['mail_from'],
    :mail_check => node['ampache']['mail_check'],
    :admin_notify_reg => node['ampache']['admin_notify_reg'],
    :max_bit_rate => node['ampache']['max_bit_rate'],
    :min_bit_rate => node['ampache']['min_bit_rate'],
    :transcode_m4a => node['ampache']['transcode_m4a'],
    :force_ssl => node['ampache']['force_ssl'],
    :transcode_m4a_target => node['ampache']['transcode_m4a_target'],
    :transcode_flac_target => node['ampache']['transcode_flac_target'],
    :transcode_mp3_target => node['ampache']['transcode_mp3_target'],
    :transcode_ogg_target => node['ampache']['transcode_ogg_target'],
    :transcode_cmd_flac => node['ampache']['transcode_cmd_flac'],
    :transcode_cmd_m4a => node['ampache']['transcode_cmd_m4a'],
    :transcode_cmd_mp3 => node['ampache']['transcode_cmd_mp3'],
    :transcode_cmd_ogg => node['ampache']['transcode_cmd_ogg'],
    :use_rss => node['ampache']['use_rss']
  ) 
    owner node['ampache']['user']
    group node['ampache']['group']
    notifies :restart, resources(:service => node['ampache']['service'])
end 

template "/etc/apache2/sites-available/ampache" do
  source "ampache.conf.erb"
  mode 755
  owner node['ampache']['user']
  group node['ampache']['group']
  notifies :restart, resources(:service => "apache2")
end 

apache_site "ampache"
