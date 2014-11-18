#
# Cookbook Name:: ganeti
#
#

### xend-config
default['ganeti']['xend-config']['logfile'] = "/var/log/xen/xend.log"
default['ganeti']['xend-config']['loglevel'] = "info"
default['ganeti']['xend-config']['vif-script'] = "vif-bridge"
default['ganeti']['xend-config']['dom0-min-mem'] = "196"
default['ganeti']['xend-config']['enable-dom0-ballooning'] = "no"
default['ganeti']['xend-config']['total_available_memory'] = "0"
default['ganeti']['xend-config']['dom0-cpus'] = "0"
default['ganeti']['xend-config']['xend-relocation-server'] = "yes"
default['ganeti']['xend-config']['xend-relocation-port'] = "8002"
default['ganeti']['xend-config']['xend-relocation-address'] = ""
default['ganeti']['xend-config']['xend-relocation-hosts-allow'] = "^.example.com$ ^10\\.0\\.0\\.[0-9]+$"
default['ganeti']['xend-config']['vncpasswd'] = ""

### xendomains
default['ganeti']['xendomains']['XENDOMAINS_SAVE'] = ""
default['ganeti']['xendomains']['XENDOMAINS_RESTORE'] = "false"
default['ganeti']['xendomains']['XENDOMAINS_AUTO'] = ""
default['ganeti']['xendomains']['XENDOMAINS_STOP_MAXWAIT'] = "300"

### interfaces
# devices
default['ganeti']['lvm']['devices']['dir'] = "/dev"
default['ganeti']['lvm']['devices']['scan'] = "/dev"
default['ganeti']['lvm']['devices']['obtain_device_list_from_udev'] = "1"
default['ganeti']['lvm']['devices']['preferred_names'] = ""
default['ganeti']['lvm']['devices']['filter'] = '"r|/dev/cdrom|", "r|/dev/drbd[0-9]+|" '
default['ganeti']['lvm']['devices']['cache_dir'] = "/run/lvm"
default['ganeti']['lvm']['devices']['cache_file_prefix'] = ""
default['ganeti']['lvm']['devices']['write_cache_state'] = "1"
default['ganeti']['lvm']['devices']['sysfs_scan'] = "1"
default['ganeti']['lvm']['devices']['multipath_component_detection'] = "1"
default['ganeti']['lvm']['devices']['md_component_detection'] = "1"
default['ganeti']['lvm']['devices']['md_chunk_alignment'] = "1"
default['ganeti']['lvm']['devices']['data_alignment_detection'] = "1"
default['ganeti']['lvm']['devices']['data_alignment'] = "0"
default['ganeti']['lvm']['devices']['data_alignment_offset_detection'] = "1"
default['ganeti']['lvm']['devices']['ignore_suspended_devices'] = "1"
default['ganeti']['lvm']['devices']['disable_after_error_count'] = "0"
default['ganeti']['lvm']['devices']['require_restorefile_with_uuid'] = "1"
default['ganeti']['lvm']['devices']['pv_min_size'] = "2048"
default['ganeti']['lvm']['devices']['issue_discards'] = "0"

# log
default['ganeti']['lvm']['log']['verbose'] = "0"
default['ganeti']['lvm']['log']['syslog'] = "1"
default['ganeti']['lvm']['log']['overwrite'] = "1"
default['ganeti']['lvm']['log']['level'] = "0"
default['ganeti']['lvm']['log']['indent'] = "1"
default['ganeti']['lvm']['log']['command_names'] = "0"
default['ganeti']['lvm']['log']['prefix'] = "  "

# backup
default['ganeti']['lvm']['backup']['backup'] = "1"
default['ganeti']['lvm']['backup']['backup_dir'] = "/etc/lvm/backup"
default['ganeti']['lvm']['backup']['archive'] = "1"
default['ganeti']['lvm']['backup']['archive_dir'] = "/etc/lvm/archive"
default['ganeti']['lvm']['backup']['retain_min'] = "10"
default['ganeti']['lvm']['backup']['retain_days'] = "30"

# shell
default['ganeti']['lvm']['shell']['history_size'] = "100"

# global
default['ganeti']['lvm']['global']['umask'] = "077"
default['ganeti']['lvm']['global']['test'] = "0"
default['ganeti']['lvm']['global']['units'] = "h"
default['ganeti']['lvm']['global']['si_unit_consistency'] = "1"
default['ganeti']['lvm']['global']['activation'] = "1"
default['ganeti']['lvm']['global']['proc'] = "/proc"
default['ganeti']['lvm']['global']['locking_type'] = "1"
default['ganeti']['lvm']['global']['wait_for_locks'] = "1"
default['ganeti']['lvm']['global']['fallback_to_clustered_locking'] = "1"
default['ganeti']['lvm']['global']['fallback_to_local_locking'] = "1"
default['ganeti']['lvm']['global']['locking_dir'] = "/run/lock/lvm"
default['ganeti']['lvm']['global']['prioritise_write_locks'] = "1"
default['ganeti']['lvm']['global']['abort_on_internal_errors'] = "0"
default['ganeti']['lvm']['global']['detect_internal_vg_cache_corruption'] = "0"
default['ganeti']['lvm']['global']['metadata_read_only'] = "0"
default['ganeti']['lvm']['global']['mirror_segtype_default'] = "mirror"
default['ganeti']['lvm']['global']['use_lvmetad'] = "0"

# activation
default['ganeti']['lvm']['activation']['checks'] = "0"
default['ganeti']['lvm']['activation']['udev_sync'] = "1"
default['ganeti']['lvm']['activation']['udev_rules'] = "1"
default['ganeti']['lvm']['activation']['verify_udev_operations'] = "0"
default['ganeti']['lvm']['activation']['retry_deactivation'] = "1"
default['ganeti']['lvm']['activation']['missing_stripe_filler'] = "error"
default['ganeti']['lvm']['activation']['use_linear_target'] = "1"
default['ganeti']['lvm']['activation']['reserved_stack'] = "64"
default['ganeti']['lvm']['activation']['reserved_memory'] = "64"
default['ganeti']['lvm']['activation']['process_priority'] = "-18"
default['ganeti']['lvm']['activation']['mirror_region_size'] = "512"
default['ganeti']['lvm']['activation']['readahead'] = "auto"
default['ganeti']['lvm']['activation']['raid_fault_policy'] = "warn"
default['ganeti']['lvm']['activation']['mirror_log_fault_policy'] = "allocate"
default['ganeti']['lvm']['activation']['mirror_image_fault_policy'] = "remove"
default['ganeti']['lvm']['activation']['snapshot_autoextend_threshold'] = "100"
default['ganeti']['lvm']['activation']['snapshot_autoextend_percent'] = "20"
default['ganeti']['lvm']['activation']['thin_pool_autoextend_threshold'] = "100"
default['ganeti']['lvm']['activation']['thin_pool_autoextend_percent'] = "20"
default['ganeti']['lvm']['activation']['thin_check_executable'] = "/sbin/thin_check -q"
default['ganeti']['lvm']['activation']['use_mlockall'] = "0"
default['ganeti']['lvm']['activation']['monitoring'] = "0"
default['ganeti']['lvm']['activation']['polling_interval'] = "15"

# dmeventd
default['ganeti']['lvm']['dmeventd']['mirror_library'] = "libdevmapper-event-lvm2mirror.so"
default['ganeti']['lvm']['dmeventd']['snapshot_library'] = "libdevmapper-event-lvm2snapshot.so"
default['ganeti']['lvm']['dmeventd']['thin_library'] = "libdevmapper-event-lvm2thin.so"
