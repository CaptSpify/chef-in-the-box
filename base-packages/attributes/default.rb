#
# Cookbook Name::base-packages
# Attributes::base-packages
#
# This started out as just base-packages, and evolved into the baseline config

default['base']['apt_file']  = "/etc/apt/sources.list"
default['base']['apt_sources'] = "apt-sources"
default['base']['example_packages'] =
  [
    'deb-multimedia-keyring'
  ]
default['base']['packages'] = 
  [ 
    'lynx',
    'molly-guard',
    'subversion',
    'dbus',
    'linux-image-amd64',
    'tcpdump',
    'libwww-perl',
    'libsys-hostname-long-perl',
    'iotop',
    'iftop',
    'debian-keyring',
    'htop',
    'bash-completion',
    'locales',
    'cifs-utils',
  ]
# I used to have a munin like you, but then I took a server to the knee
default['base']['sad_packages'] = 
  [ 
    'munin-common',
    'munin-node',
    'munin-plugins-core',
    'munin-plugins-extra',
  ]
default['base']['root_user'] = 'root'
default['base']['root_group'] = 'root'
default['base']['dirs'] = 
  [
    '/etc/postfix'
  ]
default['base']['files'] = 
  {
    '/etc/sysctl.conf' => 'sysctl.conf',
    '/etc/cron.d/chef-client' => 'chef-cron-client',
    '/etc/init.d/chef-client' => 'chef-init-client'
  }
default['base']['notify_only_execs'] = 
  {
    'apt-get-update' => '/usr/bin/apt-get update'
  }
# Yes this is correct. You too can Watch your memory usage drop like a rock if you run it --once with cron instead of as a daemon
default['base']['disabled_services'] = 
  [
    'chef-client'
  ]
default['base']['tmp_dir'] = '/tmp'
