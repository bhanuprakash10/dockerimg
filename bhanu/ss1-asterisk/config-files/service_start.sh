/bin/su - ss -l -c '/etc/init.d/starling start'
/bin/su - ss -l -c '/etc/init.d/workling start'
/bin/su - ss -l -c '/etc/init.d/ragi-0 start'
/etc/init.d/asterisk start
/etc/init.d/sshd restart
/etc/init.d/postfix restart
/etc/init.d/rsyslog restart
