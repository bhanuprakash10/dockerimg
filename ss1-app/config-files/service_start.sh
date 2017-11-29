/etc/init.d/httpd start
/etc/init.d/sshd restart
/etc/init.d/postfix restart
/etc/init.d/rsyslog restart
/bin/su - ss -l -c '/etc/init.d/starling start'
/bin/su - ss -l -c '/etc/init.d/workling start'
