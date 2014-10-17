#
# Cookbook Name:: apache2
# Attributes:: lb
#

default['apache']['http_subdomains'] = ["www","temp","web"]
default['apache']['https_subdomains'] = ["www","temp","web"]
default['apache']['domain'] = "example.com"
default['apache']['files'] =
  {
    '/usr/local/bin/apache2_module_conf_generate.pl' => 'apache2_module_conf_generate.pl',
    'example.key' => 'example.key',
    'example.crt' => 'example.crt'
  }
default['apache']['modules'] = 
  [
    "proxy",
    "proxy_http",
    "proxy_balancer"
  ]
default['apache']['sites'] = 
  [
    "lb-vhosts"
  ]
default['ampache']['dirs'] =
  [
    '/var/log/apache',
		"#{node['apache']['dir']}/sites-available",
		"#{node['apache']['dir']}/sites-enabled",
		"#{node['apache']['dir']}/mods-available",
		"#{node['apache']['dir']}/mods-enabled"
  ]
