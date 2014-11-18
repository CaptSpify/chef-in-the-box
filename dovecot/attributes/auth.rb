
default['dovecot']['auth']['system']['passdb'] = {
  # without driver
  'args' => 'dovecot',
},
{
  'driver' => 'passwd',
  'args' => '',
},
{
  'driver' => 'shadow',
  'args' => '',
}
