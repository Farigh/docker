#! /bin/bash

# Run syslog deamon
syslogd

# Run ssh deamon
/usr/sbin/sshd -D &

# Run fail2ban client
fail2ban-client -x start

# Run until the end of time
while true; do
    sleep 10
done
