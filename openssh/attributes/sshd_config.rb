default['sshd']['sshPort'] = "22",
default['sshd']['ListenAddress'] = "0.0.0.0",
default['sshd']['Protocol'] = "1",
default['sshd']['UserPrivilegeSeparation'] = "yes",
default['sshd']['SyslogFacility'] = "AUTH",
default['sshd']['LogLevel'] = "INFO",
default['sshd']['LoginGraceTime'] = "20",
default['sshd']['PermitRootLogin'] = "no",
default['sshd']['StrictModes'] = "yes",
default['sshd']['RSAAuthentication'] = "no",
default['sshd']['PubkeyAuthentication'] = "no",
default['sshd']['AuthorizedKeysFile'] = "%h/.ssh/authorized_keys",
default['sshd']['IgnoreRhosts'] = "yes",
default['sshd']['AllowAgentForwarding'] = "no",
default['sshd']['RhostsRSAAuthentication'] = "no",
default['sshd']['HostbasedAuthentication'] = "no",
default['sshd']['PermitEmptyPasswords'] = "no",
default['sshd']['ChallengeResponseAuthentication'] = "no",
default['sshd']['X11Forwarding'] = "no",
default['sshd']['X11DisplayOffset'] = "10",
default['sshd']['PrintMotd'] = "no",
default['sshd']['PrintLastLog'] = "yes",
default['sshd']['TCPKeepAlive'] = "yes",
default['sshd']['AcceptEnv'] = "LANG LC_*",
default['sshd']['Subsystem'] = "sftp /usr/lib/sftp-server",
default['sshd']['UsePAM'] = "no"
