#
# Cookbook Name:: nedi
#
# Only tested on Debian
#

# File Locations
default['nedi']['file_dir'] = "/var/nedi"
default['nedi']['conf_file'] = "nedi.conf"
default['nedi']['log_dir'] = "/var/log/apache2/"
default['nedi']['log_file'] = "nedi.log"

# File Names
default['nedi']['apache_username'] = "www-data"
default['nedi']['apache_group'] = "www-data"
