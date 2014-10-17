#
# Cookbook Name:: apache2
# Attributes:: repo
#

default['apache']['repo']['http_subdomains'] = ["repository"]
default['apache']['repo']['https_subdomains'] = ["repository"]
default['apache']['repo']['service'] = "apache2"
default['apache']['repo']['sites'] = 
  [
    "repository",
    "webdir"
  ]
default['apache']['repository']['packages'] = 
  [
    "apache2",
    "perl"
  ]
default['apache']['repo']['domain'] = "example.com"
default['apache']['repo']['default_modules'] = %w{ status alias proxy auth_basic authn_file authz_default authz_groupfile authz_host authz_user autoindex dir env mime negotiation setenvif }
