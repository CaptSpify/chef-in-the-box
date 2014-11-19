node[:keepalived][:instances][:vi_1] = {
  :ip_addresses => '10.0.0.24',
  :cidr => '/24',
  :broadcast => '10.0.0..255',
  :interface => 'eth0',
  :track_script => 'chk_init',
  :nopreempt => false,
  :advert_int => 1,
  :auth_type => "pass", # :pass or :ah
  :auth_pass => 'hahayearightpasshere'
}
