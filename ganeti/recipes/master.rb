#
# Cookbook Name:: ganeti
# Recipe:: master
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

pkgs = %w{ xen-linux-system-amd64 xen-linux-system-3.2.0-4-amd64 xen-tools xen-utils-4.1 xen-hypervisor-4.1-amd64 ganeti2 ganeti-htools drbd8-utils lvm2 openssh-server bridge-utils iproute ndisc6 python2.6 libvirt0 python-lxml python-openssl python-simplejson python-pyparsing python-pyinotify python-pycurl socat python-paramiko fping python-netaddr python-bitarray build-essential ganeti-instance-debootstrap ifenslave iputils-arping openssl python-ipaddr python-paramiko ganeti-2.10 ganeti-haskell-2.10 ganeti-htools-2.10 }

pkgs.each do |pkg|
  apt_package pkg do
    action :install
  end
end

execute "update-grub" do
  command "/usr/sbin/update-grub"
  action :nothing
end

service "lvm2" do
  service_name "lvm2"
  supports :start => true, :stop => true, :restart => true, :status => true
  action [ :enable, :start ]
end 

service "drbd" do
  service_name "drbd"
  supports :start => true, :stop => true, :restart => true, :status => true
  action [ :enable, :start ]
end 

service "xendomains" do
  service_name "xendomains"
  supports :start => true, :stop => true, :restart => true, :reload => true
  action [ :enable, :start ]
end 

service "xen" do
  service_name "xen"
  supports :start => true, :stop => true, :restart => true
  action [ :enable, :start ]
end

file "/etc/grub.d/20_linux_xen" do
  action :delete
  notifies :run, "execute[update-grub]", :delayed
end

file "/etc/grub.d/10_linux" do
  action :delete
  notifies :run, "execute[update-grub]", :delayed
end

cookbook_file "/etc/grub.d/20_linux" do
  source "20_linux"
  mode 0755
  notifies :run, "execute[update-grub]", :delayed
end

cookbook_file "/etc/grub.d/10_linux_xen" do
  source "10_linux_xen"
  mode 0755
  notifies :run, "execute[update-grub]", :delayed
end

cookbook_file "/etc/default/ganeti-instance-debootstrap" do
  source "ganeti-instance-debootstrap"
  mode 0644
end

cookbook_file "/etc/ganeti/instance-debootstrap/hooks/00-interfaces" do
  source "00-interfaces"
  mode 0755
end

template "/etc/default/grub" do
  source "grub.erb"
  mode 0744
  variables(
    :GRUB_DEFAULT => node['ganeti']['grub']['GRUB_DEFAULT'],
    :GRUB_TIMEOUT => node['ganeti']['grub']['GRUB_TIMEOUT'],
    :GRUB_DISTRIBUTOR => node['ganeti']['grub']['GRUB_DISTRIBUTOR'],
    :GRUB_CMDLINE_LINUX_DEFAULT => node['ganeti']['grub']['GRUB_CMDLINE_LINUX_DEFAULT'],
    :GRUB_CMDLINE_LINUX => node['ganeti']['grub']['GRUB_CMDLINE_LINUX'],
    :GRUB_CMDLINE_XEN => node['ganeti']['grub']['GRUB_CMDLINE_XEN']
  )
  notifies :run, "execute[update-grub]", :immediately
end

template "/etc/xen/xend-config.sxp" do
  source "xend-config.sxp.erb"
  variables(
    :logfile => node['ganeti']['xend-config']['logfile'],
    :loglevel => node['ganeti']['xend-config']['loglevel'],
    :vif_script => node['ganeti']['xend-config']['vif-script'],
    :dom0_min_mem => node['ganeti']['xend-config']['dom0-min-mem'],
    :enable_dom0_ballooning => node['ganeti']['xend-config']['enable-dom0-ballooning'],
    :total_available_memory => node['ganeti']['xend-config']['total_available_memory'],
    :dom0_cpus => node['ganeti']['xend-config']['dom0-cpus'],
    :xend_http_server => node['ganeti']['xend-config']['xend-http-server'],
    :xend_unix_server => node['ganeti']['xend-config']['xend-unix-server'],
    :xend_tcp_xmlrpc_server => node['ganeti']['xend-config']['xend-tcp-xmlrpc-server'],
    :xend_unix_xmlrpc_server => node['ganeti']['xend-config']['xend-unix-xmlrpc-server'],
    :xend_relocation_server => node['ganeti']['xend-config']['xend-relocation-server'],
    :xend_relocation_port => node['ganeti']['xend-config']['xend-relocation-port'],
    :xend_relocation_address => node['ganeti']['xend-config']['xend-relocation-address'],
    :vncpasswd => node['ganeti']['xend-config']['vncpasswd']
  )
  notifies :restart, resources(:service => "xen")
end

template "/etc/default/xendomains" do
  source "xendomains.erb"
  variables(
    :XENDOMAINS_SAVE => node['ganeti']['xendomains']['XENDOMAINS_SAVE'],
    :XENDOMAINS_RESTORE => node['ganeti']['xendomains']['XENDOMAINS_RESTORE'],
    :XENDOMAINS_AUTO => node['ganeti']['xendomains']['XENDOMAINS_AUTO'],
    :XENDOMAINS_STOP_MAXWAIT => node['ganeti']['xendomains']['XENDOMAINS_STOP_MAXWAIT']
  )
  notifies :restart, resources(:service => "xendomains")
end

cookbook_file "/etc/ganeti/instance-debootstrap/variants.list" do
  source "variants.list"
  notifies :restart, resources(:service => "xen")
end

cookbook_file "/etc/ganeti/instance-debootstrap/variants/wheezy.conf" do
  source "wheezy.conf"
  notifies :restart, resources(:service => "xen")
end

link "/boot/vmlinuz-3-xenU" do
  to "/boot/vmlinuz-3.2.0-4-amd64"
  link_type :symbolic
end

link "/boot/initrd-3-xenU" do
  to "/boot/initrd.img-3.2.0-4-amd64"
  link_type :symbolic
end

directory "/root/.ssh" do
  action :create
  mode 0700
end

cookbook_file "/root/.ssh/id_dsa" do
  source "id_dsa"
end

cookbook_file "/root/.ssh/authorized_keys" do
  source "id_dsa.pub"
end

cookbook_file "/root/.ssh/id_dsa.pub" do
  source "id_dsa.pub"
end

cookbook_file "/etc/bash_completion.d/brctl" do
  source "brctl"
end

cookbook_file "/etc/drbd.conf" do
  source "drbd.conf"
  notifies :restart, resources(:service => "drbd")
end

link "/usr/lib/ganeti/vif-ganeti" do
  to "/etc/xen/scripts/vif-ganeti"
  link_type :symbolic
end

link "/boot/vmlinuz-2.6-xenU" do
  to "/boot/vmlinuz-3-xenU"
  link_type :symbolic
end

link "/usr/lib/xen" do
  to "/usr/lib/xen-4.1"
  link_type :symbolic
end

cookbook_file "/etc/ganeti/vnc-cluster-password" do
  source "vnc-cluster-password"
end

template "/etc/lvm/lvm.conf" do
  source "lvm.conf.erb"
  variables(
    :devices_dir => node['ganeti']['lvm']['devices']['dir'],
    :devices_scan => node['ganeti']['lvm']['devices']['scan'],
    :devices_obtain_device_list_from_udev => node['ganeti']['lvm']['devices']['obtain_device_list_from_udev'],
    :devices_preferred_names => node['ganeti']['lvm']['devices']['preferred_names'],
    :devices_filter => node['ganeti']['lvm']['devices']['filter'],
    :devices_cache_dir=> node['ganeti']['lvm']['devices']['cache_dir'],
    :devices_cache_file_prefix => node['ganeti']['lvm']['devices']['cache_file_prefix'],
    :devices_write_cache_state => node['ganeti']['lvm']['devices']['write_cache_state'],
    :devices_sysfs_scan => node['ganeti']['lvm']['devices']['sysfs_scan'],
    :devices_multipath_component_detection => node['ganeti']['lvm']['devices']['multipath_component_detection'],
    :devices_md_component_detection => node['ganeti']['lvm']['devices']['md_component_detection'],
    :devices_md_chunk_alignment => node['ganeti']['lvm']['devices']['md_chunk_alignment'],
    :devices_data_alignment_detection => node['ganeti']['lvm']['devices']['data_alignment_detection'],
    :devices_data_alignment => node['ganeti']['lvm']['devices']['data_alignment'],
    :devices_data_alignment_offset_detection => node['ganeti']['lvm']['devices']['data_alignment_offset_detection'],
    :devices_ignore_suspended_devices => node['ganeti']['lvm']['devices']['ignore_suspended_devices'],
    :devices_disable_after_error_count => node['ganeti']['lvm']['devices']['disable_after_error_count'],
    :devices_require_restorefile_with_uuid => node['ganeti']['lvm']['devices']['require_restorefile_with_uuid'],
    :devices_pv_min_size => node['ganeti']['lvm']['devices']['pv_min_size'],
    :devices_issue_discards => node['ganeti']['lvm']['devices']['issue_discards'],
    :log_verbose => node['ganeti']['lvm']['log']['verbose'],
    :log_syslog => node['ganeti']['lvm']['log']['syslog'],
    :log_overwrite => node['ganeti']['lvm']['log']['overwrite'],
    :log_level => node['ganeti']['lvm']['log']['level'],
    :log_indent => node['ganeti']['lvm']['log']['indent'],
    :log_command_names => node['ganeti']['lvm']['log']['command_names'],
    :log_prefix => node['ganeti']['lvm']['log']['prefix'],
    :backup_backup => node['ganeti']['lvm']['backup']['backup'],
    :backup_backup_dir => node['ganeti']['lvm']['backup']['backup_dir'],
    :backup_archive => node['ganeti']['lvm']['backup']['archive'],
    :backup_archive_dir => node['ganeti']['lvm']['backup']['archive_dir'],
    :backup_retain_min => node['ganeti']['lvm']['backup']['retain_min'],
    :backup_retain_days => node['ganeti']['lvm']['backup']['retain_days'],
    :shell_history_size => node['ganeti']['lvm']['shell']['history_size'],
    :global_umask => node['ganeti']['lvm']['global']['umask'],
    :global_test => node['ganeti']['lvm']['global']['test'],
    :global_units => node['ganeti']['lvm']['global']['units'],
    :global_si_unit_consistency => node['ganeti']['lvm']['global']['si_unit_consistency'],
    :global_activation => node['ganeti']['lvm']['global']['activation'],
    :global_proc => node['ganeti']['lvm']['global']['proc'],
    :global_locking_type => node['ganeti']['lvm']['global']['locking_type'],
    :global_wait_for_locks => node['ganeti']['lvm']['global']['wait_for_locks'],
    :global_fallback_to_clustered_locking => node['ganeti']['lvm']['global']['fallback_to_clustered_locking'],
    :global_fallback_to_local_locking => node['ganeti']['lvm']['global']['fallback_to_local_locking'],
    :global_locking_dir => node['ganeti']['lvm']['global']['locking_dir'],
    :global_prioritise_write_locks => node['ganeti']['lvm']['global']['prioritise_write_locks'],
    :global_abort_on_internal_errors => node['ganeti']['lvm']['global']['abort_on_internal_errors'],
    :global_detect_internal_vg_cache_corruption => node['ganeti']['lvm']['global']['detect_internal_vg_cache_corruption'],
    :global_metadata_read_only => node['ganeti']['lvm']['global']['metadata_read_only'],
    :global_mirror_segtype_default => node['ganeti']['lvm']['global']['mirror_segtype_default'],
    :global_use_lvmetad => node['ganeti']['lvm']['global']['use_lvmetad'],
    :activation_checks => node['ganeti']['lvm']['activation']['checks'],
    :activation_udev_sync => node['ganeti']['lvm']['activation']['udev_sync'],
    :activation_udev_rules => node['ganeti']['lvm']['activation']['udev_rules'],
    :activation_verify_udev_operations => node['ganeti']['lvm']['activation']['verify_udev_operations'],
    :activation_retry_deactivation => node['ganeti']['lvm']['activation']['retry_deactivation'],
    :activation_missing_stripe_filler => node['ganeti']['lvm']['activation']['missing_stripe_filler'],
    :activation_use_linear_target => node['ganeti']['lvm']['activation']['use_linear_target'],
    :activation_reserved_stack => node['ganeti']['lvm']['activation']['reserved_stack'],
    :activation_reserved_memory => node['ganeti']['lvm']['activation']['reserved_memory'],
    :activation_process_priority => node['ganeti']['lvm']['activation']['process_priority'],
    :activation_mirror_region_size => node['ganeti']['lvm']['activation']['mirror_region_size'],
    :activation_readahead => node['ganeti']['lvm']['activation']['readahead'],
    :activation_raid_fault_policy => node['ganeti']['lvm']['activation']['raid_fault_policy'],
    :activation_mirror_log_fault_policy => node['ganeti']['lvm']['activation']['mirror_log_fault_policy'],
    :activation_mirror_image_fault_policy => node['ganeti']['lvm']['activation']['mirror_image_fault_policy'],
    :activation_snapshot_autoextend_threshold => node['ganeti']['lvm']['activation']['snapshot_autoextend_threshold'],
    :activation_snapshot_autoextend_percent => node['ganeti']['lvm']['activation']['snapshot_autoextend_percent'],
    :activation_thin_pool_autoextend_threshold => node['ganeti']['lvm']['activation']['thin_pool_autoextend_threshold'],
    :activation_thin_pool_autoextend_percent => node['ganeti']['lvm']['activation']['thin_pool_autoextend_percent'],
    :activation_thin_check_executable => node['ganeti']['lvm']['activation']['thin_check_executable'],
    :activation_use_mlockall => node['ganeti']['lvm']['activation']['use_mlockall'],
    :activation_monitoring => node['ganeti']['lvm']['activation']['monitoring'],
    :activation_polling_interval => node['ganeti']['lvm']['activation']['polling_interval'],
    :dmeventd_mirror_library => node['ganeti']['lvm']['dmeventd']['mirror_library'],
    :dmeventd_snapshot_library => node['ganeti']['lvm']['dmeventd']['snapshot_library'],
    :dmeventd_thin_library => node['ganeti']['lvm']['dmeventd']['thin_library'],
  )
  notifies :restart, resources(:service => "lvm2")
end

###### Here be dragons. I would reccomend you change the entire section below this, as it's heavily set up for my env. If you blindly use it, may god have mercy on your soul

# We need to make sure we're running the drbd modules
script "drbd_module_check" do
  interpreter "bash"
  user "root"
  code <<-EOH
  if /bin/lsmod | grep drbd > /dev/null; then
    echo -n
  else
    echo drbd minor_count=128 usermode_helper=/bin/true >> /etc/modules
    depmod -a
    modprobe drbd minor_count=128 usermode_helper=/bin/true
  fi
  EOH
end

# Make sure we have an lvm disk
script "pvs_check" do
  interpreter "bash"
  user "root"
  code <<-EOH
  if /sbin/pvs | grep sdb1 > /dev/null; then
    echo -n
  else
    pvcreate /dev/sdb1
  fi
  EOH
end

script "vgdisk_check" do
  interpreter "bash"
  user "root"
  code <<-EOH
  if /sbin/vgdisplay -s | grep xenvg > /dev/null; then
    echo -n
  else
    vgcreate xenvg /dev/sdb1
  fi
  EOH
end

script "cluster_check" do
  interpreter "bash"
  user "root"
  code <<-EOH
  if /usr/sbin/gnt-cluster info 2>/dev/null >/dev/null; then
    echo -n
  else
    if /bin/grep "usermode_helper" /etc/modules > /dev/null; then
      /usr/sbin/gnt-cluster init --enabled-hypervisors=xen-pvm ganeti
    else
      echo drbd minor_count=128 usermode_helper=/bin/true >> /etc/modules
      depmod -a
      modprobe drbd minor_count=128 usermode_helper=/bin/true
      /sbin/reboot
    fi
  fi
  EOH
end
