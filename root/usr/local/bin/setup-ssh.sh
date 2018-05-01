#!/bin/sh

USER="www"

if [ ! -f "/etc/ssh/ssh_host_rsa_key" ]; then
    # generate fresh rsa key
    ssh-keygen -f /etc/ssh/ssh_host_rsa_key -N '' -t rsa &
fi
if [ ! -f "/etc/ssh/ssh_host_dsa_key" ]; then
    # generate fresh dsa key
    ssh-keygen -f /etc/ssh/ssh_host_dsa_key -N '' -t dsa &
fi
if [ ! -f "/etc/ssh/ssh_host_ecdsa_key" ]; then
    # generate fresh ecdsa key
    ssh-keygen -f /etc/ssh/ssh_host_ecdsa_key -N '' -t ecdsa &
fi
if [ ! -f "/etc/ssh/ssh_host_ed25519_key" ]; then
    # generate fresh ed25519 key
    ssh-keygen -f /etc/ssh/ssh_host_ed25519_key -N '' -t ed25519 &
fi

wait `jobs -p` || true

#Prepare run dir
if [ ! -d "/var/run/sshd" ]; then
  mkdir -p /var/run/sshd
fi

echo "PasswordAuthentication no" >> /etc/ssh/sshd_config

echo "UsePAM yes
    Match User $USER
    ChrootDirectory /www
    ForceCommand internal-sftp
    X11Forwarding no
    AllowTcpForwarding no" >> /etc/ssh/sshd_config
