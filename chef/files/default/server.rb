# Configuration File For Chef (chef-server)
#
# chef-server is a Merb application slice that provides the Chef API.
#
# By default it is configured to run via Thin. It can be run manually as:
#
#		chef-server -p 4000 -e production -a thin
#
# This starts up the RESTful Chef Server API on port 4000 in production mode
# using the thin server adapter.
#
# This file configures the behavior of the running server itself.
#
# It is a Ruby DSL config file, and can embed regular Ruby code in addition to
# the configuration settings. Some settings use Ruby symbols, which are a value
# that starts with a colon. In Ruby, anything but 'false' or 'nil' is true. To
# set something to false:
#
# some_setting false
#
# log_level specifies the level of verbosity for output.
# valid values are: :debug, :info, :warn, :error, :fatal

log_level          :error
#log_level          :debug

# log_location specifies where the server should log to.
# valid values are: a quoted string specifying a file, or STDOUT with
# no quotes. This is the application log for the Merb workers that get
# spawned. The chef-server daemon is configured to log to
# /var/log/chef/server.log in /etc/chef/default/chef-server.

log_location       "/var/log/chef/server.log"

# ssl_verify_mode specifies if the REST client should verify SSL certificates.
# valid values are :verify_none, :verify_peer. The default Chef Server
# installation on Debian will use a self-generated SSL certificate so this
# should be :verify_none unless you replace the certificate.

ssl_verify_mode    :verify_none

# chef_server_url specifies the URL for the server API. The process actually
# listens on 0.0.0.0:PORT. valid values are any HTTP URL. To change the port
# the server listens on, modify /etc/default/chef-server.

chef_server_url    "http://localhost:4000"

# cookbook_path is a Ruby array of filesystem locations to search for cookbooks
# that are available for clients. This is also where cookbooks uploaded via
# 'knife' are stored.
#
# valid value is a string, or an array of strings of filesystem directory locations.
# This setting is searched beginning (index 0) to end in order. You might specify
# multiple search paths for cookbooks if you want to use an upstream source, and
# provide localised "site" overrides. These should come after the 'upstream' source.
# The default value, /var/lib/chef/cookbooks does not contain any cookbooks by default.
#
# See the Chef Wiki for more information about setting up a local repository for
# working on cookbooks: http://wiki.opscode.com/display/chef/Chef+Repository
#
# NOTE: cookbook_path is a deprecated setting for the Chef Server. This option
# remains here for compatibility because the default in Chef is not FHS compliant.
# This option may be removed in a future version.

cookbook_path      [ "/var/lib/chef/cookbooks" ]

# cookbook_tarball_path is the location where the server will store uploaded
# cookbook tarballs. These tarballs can be downloaded with knife, for
# redistribution.
#
# NOTE: cookbook_tarball_path is a deprecated setting for the Chef Server.
# This option remains here for compatibility because the default in Chef is
# not FHS compliant. This option may be removed in a future version.

cookbook_tarball_path "/var/lib/chef/cookbook-tarballs"

# sandbox_path is the location where the chef server temporarily stores files
# uploaded for cookbooks.

sandbox_path "/var/cache/chef/sandboxes"

# checksum_path sets the location for the checksum index for each cookbook
# file uploaded.
#
# NOTE: Important change in version 0.9.10+, this location is different
# so it doesn't conflict with the cached checksums from the chef client.

checksum_path "/var/lib/chef/cookbook_index"

# file_cache_path specifies where chef should cache cookbooks, server
# cookie ID, and openid registration data.
# valid value is any filesystem directory location.

file_cache_path    "/var/cache/chef"

# node_path specifies a location for where to find node-specific recipes.
# valid values are any filesystem direcory location.

node_path          "/var/lib/chef/nodes"

# openid_store_path specifies a location where to keep openid nonces for clients.
# valid values are any filesystem directory location.
#
# NOTE: OpenID is deprecated and this option may not be used, kept for
# historical purposes because the default in Chef is not FHS compliant, and
# may be removed in a future version.

openid_store_path  "/var/lib/chef/openid/store"

# openid_store_path specifies a location where to keep openid nonces for clients.
# valid values are any filesystem directory location.
#
# NOTE: OpenID is deprecated and this option may not be used, kept for
# historical purposes because the default in Chef is not FHS compliant, and
# may be removed in a future version.

openid_cstore_path "/var/lib/chef/openid/cstore"

# role_path designates where the server should load role JSON and Ruby DSL
# files from.
# valid values are any filesystem directory location. Roles are a feature
# that allow you to easily reuse lists of recipes and attribute settings.
# Please see the Chef Wiki page for information on how to utilize the feature.
# http://wiki.opscode.com/display/chef/Roles
#
# NOTE: The role_path setting is deprecated on the chef-server, as the
# roles are now stored directly in CouchDB rather than on the filesystem.
# This option is kept for historical purposes because the default in Chef is
# not FHS compliant, and may be removed in a future version.

#role_path          "/var/lib/chef/roles"

# cache_options sets options used by the moneta library for local cache
# for checksums of compared objects.

cache_options({ :path => "/var/cache/chef/checksums", :skip_expires => true})

# Mixlib::Log::Formatter.show_time specifies whether the chef-client log should
# contain timestamps.
# valid values are true or false. The printed timestamp is rfc2822, for example:
# Fri, 31 Jul 2009 19:19:46 -0600

Mixlib::Log::Formatter.show_time = true

# The following options configure the signing CA so it can be read by
# non-privileged user for the server daemon.

signing_ca_cert "/etc/chef/certificates/cert.pem"
signing_ca_key "/etc/chef/certificates/key.pem"
signing_ca_user "chef"
signing_ca_group "chef"

# amqp_pass sets the password for the AMQP virtual host in rabbitmq-server.

amqp_pass "rabbitmqpasswordonlyacceptsplaintextwtf"
