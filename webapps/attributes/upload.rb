#
# Cookbook Name:: upload
#
# Uploads a file to a temporary directory which is cleared out by cron
# Only tested on Debian
#

# File Locations
default['upload']['file_dir'] = "/var/www/tmp/"
default['upload']['log_dir'] = "/var/log/apache2/"
default['upload']['log_file'] = "upload.log"
default['upload']['apache_dir'] = "/etc/apache2/"

# File Names
default['upload']['htaccess_file'] = "upload.htaccess"
default['upload']['apache_username'] = "www-data"
default['upload']['apache_group'] = "www-data"

# htaccess
default['upload']['AuthType'] = "Basic"
default['upload']['AuthName'] = "Upload Files"
default['upload']['Require'] = "valid-user"
