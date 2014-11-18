
default['dovecot']['services'] = {}
node.default['dovecot']['services']['imap-login'] = {
  'listeners' => [
    { 'inet:imap' => {
     'port' => 553,
    } },
    { 'inet:imaps' => {
      'port' => 551,
      'ssl' => true,
    } },
  ],
  'service_count' => 1,
  'process_min_avail' => 0,
  'vsz_limit' => '32M',
}
