default["sec"]["daemon_config"] = "/etc/sec/daemon_config"
default["sec"]["rules_file"] = "/var/sec/rules"
default["sec"]["run_daemon"] = "yes"
default["sec"]["daemon_args"] = "-conf=/etc/sec/rules -input=/var/log/sec.syslog.log -pid=/var/run/sec.pid -detach -log=/var/log/sec.log"
