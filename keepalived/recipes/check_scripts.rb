node[:keepalived][:check_scripts][:chk_init] = {
  :script => 'killall -0 init',
  :interval => 2,
  :weight => 2
}
