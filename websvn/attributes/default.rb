# apache.conf
set['websvn']['alias'] = "/"
set['websvn']['directory'] = "/usr/share/websvn/"
set['websvn']['directory_index'] = "index.php"

# svn_deb_conf
set['websvn']['parent_path'] = "/var/svn-server"
set['websvn']['enscript_path'] = "/usr/bin"
set['websvn']['sed_path'] = "/bin"

# ports.conf
default['websvn']['listen_ports'] = [ "80","443","81" ]
