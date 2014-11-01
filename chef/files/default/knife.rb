log_level                :info
log_location             STDOUT
node_name                'chef-webui'
client_key               '/etc/chef/webui.pem'
validation_client_name   'chef-validator'
validation_key           '/etc/chef/validation.pem'
chef_server_url          'http://server.example.com:4000'
cache_type               'BasicFile'
cache_options( :path => '/home/user/checksums' )
cookbook_path [ '/home/user/cookbooks' ]
