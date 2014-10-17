#
# Cookbook Name:: apache2
# Attributes:: apache
#
# Copyright 2008-2009, Opscode, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

default['apache']['root_user']  = "root"
default['apache']['root_group']  = "root"
default['apache']['service']  = "apache2"
default['apache']['packages'] = 
  [ 
    "apache2",
    "perl"
  ]
default['apache']['dir']     = "/etc/apache2"
default['apache']['dirs'] =
  [
    "#{node['apache']['dir']}/ssl",
    "#{node['apache']['dir']}/conf.d",
    "/var/cache/apache2",
    "/var/log/apache2"
  ]
default['apache']['log_dir'] = "/var/log/apache2"
default['apache']['error_log'] = "error.log"
default['apache']['user']    = "www"
default['apache']['group']   = "www"
default['apache']['binary']  = "/usr/sbin/apache2"
default['apache']['icondir'] = "/usr/share/apache2/icons"
default['apache']['pid_file']  = "/var/run/apache2.pid"
default['apache']['lib_dir'] = "/usr/lib/apache2"
default['apache']['libexecdir'] = "#{default['apache']['lib_dir']}/modules"
default['apache']['default_site_enabled'] = true

###
# These settings need the unless, since we want them to be tunable,
# and we don't want to override the tunings.
###

# General settings
default['apache']['listen_ports'] = [ "80","443" ]
default['apache']['contact'] = "admin@example.com"
default['apache']['timeout'] = 30
default['apache']['keepalive'] = "Off"
default['apache']['keepaliverequests'] = 10
default['apache']['keepalivetimeout'] = 5

# Security
default['apache']['servertokens'] = "Prod"
default['apache']['serversignature'] = "On"
default['apache']['traceenable'] = "On"
default['apache']['hide'] = "\.git"

# mod_auth_openids
default['apache']['allowed_openids'] = Array.new

# Prefork Attributes
default['apache']['prefork']['startservers'] = 5
default['apache']['prefork']['minspareservers'] = 5
default['apache']['prefork']['maxspareservers'] = 10
default['apache']['prefork']['serverlimit'] = 40
default['apache']['prefork']['maxclients'] = 40
default['apache']['prefork']['maxrequestsperchild'] = 100

# Worker Attributes
default['apache']['worker']['startservers'] = 5
default['apache']['worker']['maxclients'] = 32
default['apache']['worker']['minsparethreads'] = 8
default['apache']['worker']['maxsparethreads'] = 16
default['apache']['worker']['threadsperchild'] = 32
default['apache']['worker']['maxrequestsperchild'] = 100

# Default modules to enable via include_recipe 
default['apache']['default_modules'] = %w{ status alias proxy auth_basic authn_file authz_default authz_groupfile authz_host authz_user autoindex dir env mime negotiation setenvif }
