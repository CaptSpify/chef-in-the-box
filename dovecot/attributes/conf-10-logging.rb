
# conf.d/10-logging.conf

default['dovecot']['conf']['log_path'] = '/var/log/dovecot.log'
default['dovecot']['conf']['info_log_path'] = '/var/log/dovecot.log'
default['dovecot']['conf']['debug_log_path'] = '/var/log/dovecot.log'
default['dovecot']['conf']['syslog_facility'] = nil
default['dovecot']['conf']['auth_verbose'] = false
default['dovecot']['conf']['auth_verbose_passwords'] = nil
default['dovecot']['conf']['auth_debug'] = false
default['dovecot']['conf']['auth_debug_passwords'] = nil
default['dovecot']['conf']['mail_debug'] = false
default['dovecot']['conf']['verbose_ssl'] = nil
default['dovecot']['conf']['log_timestamp'] = '%Y-%m-%d %H:%M:%S - '
default['dovecot']['conf']['login_log_format_elements'] = nil
default['dovecot']['conf']['login_log_format'] = nil
default['dovecot']['conf']['mail_log_prefix'] = nil
default['dovecot']['conf']['deliver_log_format'] = nil

