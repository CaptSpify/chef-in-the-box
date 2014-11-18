
default['dovecot']['user'] = 'dovecot'
default['dovecot']['group'] = 'dovecot'

case node['platform']
  when 'redhat','centos','scientific','fedora','suse','amazon' then
    default['dovecot']['lib_path'] = '/usr/libexec/dovecot'
  else
    default['dovecot']['lib_path'] = '/usr/lib/dovecot'
end

