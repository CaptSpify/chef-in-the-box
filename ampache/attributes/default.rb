default['ampache']['packages'] = 
  [ 
    'ampache',
    'openjdk-6-jre',
    'ffmpeg',
    'flac',
    'lame' 
  ]
default['ampache']['symlinks'] = 
  { 
    '/etc/ampache/ampache.cfg.php' => '/usr/share/ampache/www/config/ampache.cfg.php' 
  }
default['ampache']['files'] = 
  { 
    '/usr/share/ampache/www/modules/flash/xspf_jukebox.swf' => 'xspf_jukebox.swf',
    '/usr/share/ampache/www/lib/init.php' => 'init.php',
    '/usr/share/ampache/www/lib/init-tiny.php' => 'init-tiny.php',
    '/usr/share/ampache/www/healthcheck.txt' => 'healthcheck.txt'
  }
default['ampache']['dirs'] = 
  [
    '/usr/share/ampache',
    '/var/log/ampache'
  ]
default['ampache']['service'] = 'apache2'
default['ampache']['user'] = 'www'
default['ampache']['group'] = 'www'
default['apache']['sites'] =
  [
    "lb-vhosts"
  ]
