#! /bin/bash

docker_user=sshuser
sshd_config_file=/etc/ssh/sshd_config
fail2ban_config_file=/etc/fail2ban/jail.conf

### Create new user
useradd --password '*' --create-home --home-dir /home/$docker_user --shell /bin/bash $docker_user

apt-get update

### Install syslog
apt-get install -y busybox-syslogd

### Install sshd
apt-get install -y openssh-server
mkdir -p /var/run/sshd

#########################
# Enhance sshd security #
#########################

# Disable root login
sed -i "s/^PermitRootLogin \(.*\)/PermitRootLogin no/" $sshd_config_file

# Enable host auth
sed -i "s/^HostbasedAuthentication \(.*\)/HostbasedAuthentication yes/" $sshd_config_file

# Disable clear text passwords auth (uncomment if needed)
sed -i "s/^\(#\)*PasswordAuthentication \(.*\)/PasswordAuthentication no/" $sshd_config_file

# Disable display forwarding
sed -i "s/^X11Forwarding \(.*\)/X11Forwarding no/" $sshd_config_file

# Disable PAM module
sed -i "s/^UsePAM \(.*\)/UsePAM no/" $sshd_config_file

### Install Fail2ban
apt-get install -y fail2ban

mkdir -p /var/run/fail2ban

# Change sshd log path in fail2ban config
sed -i "s#logpath = %(sshd_log)s#logpath = /var/log/messages#g" $fail2ban_config_file

# Add fail2ban ssh config
cat <<EOF >> $fail2ban_config_file
[ssh]
enabled = true
port    = ssh
filter  = sshd
logpath  = /var/log/messages
maxretry = 6
EOF

# Clean up APT when done.
apt-get autoremove --purge && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
