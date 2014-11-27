# encoding => utf-8
# Author: => Joshua Timberman <joshua@opscode.com>
# Copyright: => Copyright (c) 2009, Opscode, Inc.
# License: => Apache License, Version 2.0
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Generic cookbook attributes
default['postfix']['mail_type']  = 'client'
default['postfix']['relayhost_role'] = 'mail'
default['postfix']['multi_environment_relay'] = false
default['postfix']['use_procmail'] = false
default['postfix']['main_template_source'] = 'postfix'
default['postfix']['master_template_source'] = 'postfix'
default['postfix']['sender_canonical_map_entries'] = {}
default['postfix']['virtual_mailbox_map_file'] = '/etc/postfix/virtual'
default['postfix']['virtual_alias_map_file'] = '/etc/aliases'
default['postfix']['virtual_uid_map_file'] = '/etc/postfix/virtual_uid_map'
default['postfix']['virtual_gid_map_file'] = '/etc/postfix/virtual_gid_map'

# Aliases list
default['postfix']['aliases'] = {
  :"mailer-daemon" => "postmaster",
  :postmaster => "root",
  :nobody => "root",
  :hostmaster => "root",
  :usenet => "root",
  :news => "root",
  :webmaster => "root",
  :www => "root",
  :"www-data" => "root",
  :ftp => "root",
  :abuse => "root",
  :noc => "root",
  :security => "root",
}

# virtual list (allows regex)
default['postfix']['virtual'] = {
  :"root" => "user1",
  :"www" => "user1",
  :"www-data" => "user1",
  :"root@mail.example.com" => "user1",
  :"root@example.com" => "user1",
  :"user1@example.com" => "user1",
  :"*@example.com" => "user1",
  :"user1" => "user1",
}

# needs to be waaaaaaaaaaaay more dynamic
default['postfix']['virtual_map'] = {
  :user1 => "1000"
}

case node['platform']
when 'smartos'
  default['postfix']['conf_dir'] = '/opt/local/etc/postfix'
  default['postfix']['aliases_db'] = '/opt/local/etc/postfix/aliases'
else
  default['postfix']['conf_dir'] = '/etc/postfix'
  default['postfix']['aliases_db'] = '/etc/aliases'
end

# default main.cf attributes
default['postfix']['main']['biff'] = 'no'
default['postfix']['main']['append_dot_mydomain'] = 'no'
default['postfix']['main']['myhostname'] = (node['fqdn'] || node['hostname']).to_s.chomp('.')
default['postfix']['main']['mydomain'] = (node['domain'] || node['hostname']).to_s.chomp('.')
default['postfix']['main']['myorigin'] = 'example.com'
default['postfix']['main']['mydestination'] = ''
default['postfix']['main']['smtpd_use_tls'] = 'yes'
default['postfix']['main']['smtp_use_tls'] = 'yes'
default['postfix']['main']['mailbox_size_limit'] = 0
default['postfix']['main']['recipient_delimiter'] = '+'
default['postfix']['main']['smtp_sasl_auth_enable'] = 'yes'
default['postfix']['main']['mynetworks'] = '10.0.0/24'
default['postfix']['main']['inet_interfaces'] = 'loopback-only'
default['postfix']['main']['smtpd_tls_security_level'] = 'may'
default['postfix']['main']['smtpd_tls_auth_only'] = 'yes'
default['postfix']['main']['broken_sasl_auth_clients'] = 'no'
default['postfix']['main']['smtpd_recipient_restrictions'] = 'permit_mynetworks, permit_sasl_authenticated, reject_unauth_destination'
default['postfix']['main']['luser_relay'] = 'user1'
# I have no idea where this is being set
node['postfix']['main']['relayhost'] = 'mail.example.com'

# Conditional attributes
case node['platform']
when 'smartos'
  default['postfix']['main']['smtpd_use_tls'] = 'no'
  default['postfix']['main']['smtp_use_tls'] = 'no'
  cafile = '/opt/local/etc/postfix/cacert.pem'
when 'rhel'
  cafile = '/etc/pki/tls/cert.pem'
else
  #cafile = '/etc/postfix/cacert.pem'
  # Not really needed...maybe?
  cafile = ''
end

if node['postfix']['use_procmail']
  default['postfix']['main']['mailbox_command'] = '/usr/bin/procmail -a "$EXTENSION"'
end

if node['postfix']['main']['smtpd_use_tls'] == 'yes'
  default['postfix']['main']['smtpd_tls_cert_file'] = '/etc/ssl/certs/example.pem'
  default['postfix']['main']['smtpd_tls_key_file'] = '/etc/ssl/private/example.key'
  default['postfix']['main']['smtpd_tls_CAfile'] = cafile
  default['postfix']['main']['smtpd_tls_session_cache_database'] = 'btree:${data_directory}/smtpd_scache'
end

if node['postfix']['main']['smtp_use_tls'] == 'yes'
  default['postfix']['main']['smtp_tls_CAfile'] = cafile
  default['postfix']['main']['smtp_tls_session_cache_database'] = 'btree:${data_directory}/smtp_scache'
end

if node['postfix']['main']['smtp_sasl_auth_enable'] == 'yes'
  default['postfix']['main']['smtp_sasl_password_maps'] = "hash:#{node['postfix']['conf_dir']}/sasl_passwd"
  default['postfix']['main']['smtp_sasl_security_options'] = 'noanonymous'
  default['postfix']['sasl']['smtp_sasl_user_name'] = ''
  default['postfix']['sasl']['smtp_sasl_passwd']  = ''
  default['postfix']['sasl']['smtpd_sasl_type']  = 'dovecot'
end

### for pam auth
default['postfix']['smtpd']['pwcheck_method'] = 'saslauthd'
default['postfix']['smtpd']['mech_list'] = 'PLAIN LOGIN'
default['postfix']['smtpd']['allow_plaintext'] = 'false'

default['postfix']['saslauthd']['start'] = 'yes'
default['postfix']['saslauthd']['description'] = 'SASL Authentication Daemon'
default['postfix']['saslauthd']['name'] = 'saslauthd'
default['postfix']['saslauthd']['mechanisms'] = 'passwd'
default['postfix']['saslauthd']['mech_options'] = ''
default['postfix']['saslauthd']['threads'] = '5'
default['postfix']['saslauthd']['options'] = '-c -m /var/run/saslauthd'

# # Default main.cf attributes according to `postconf -d`
# default['postfix']['main']['relayhost'] = ''
# default['postfix']['main']['milter_default_action']  = 'tempfail'
# default['postfix']['main']['milter_protocol']  = '6'
# default['postfix']['main']['smtpd_milters']  = ''
# default['postfix']['main']['non_smtpd_milters']  = ''
# default['postfix']['main']['sender_canonical_classes'] = nil
# default['postfix']['main']['recipient_canonical_classes'] = nil
# default['postfix']['main']['canonical_classes'] = nil
# default['postfix']['main']['sender_canonical_maps'] = nil
# default['postfix']['main']['recipient_canonical_maps'] = nil
# default['postfix']['main']['canonical_maps'] = nil

# Master.cf attributes
default['postfix']['master']['submission'] = true
