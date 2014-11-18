
# conf.d/15-lda.conf

default['dovecot']['conf']['postmaster_address'] = 'postmaster@example.com'
default['dovecot']['conf']['hostname'] = 'mail.example.com'
default['dovecot']['conf']['quota_full_tempfail'] = nil
default['dovecot']['conf']['sendmail_path'] = '/usr/sbin/sendmail'
default['dovecot']['conf']['submission_host'] = nil
default['dovecot']['conf']['rejection_subject'] = nil
default['dovecot']['conf']['rejection_reason'] = nil
default['dovecot']['conf']['recipient_delimiter'] = nil
default['dovecot']['conf']['lda_original_recipient_header'] = nil
default['dovecot']['conf']['lda_mailbox_autocreate'] = true
default['dovecot']['conf']['lda_mailbox_autosubscribe'] = nil

