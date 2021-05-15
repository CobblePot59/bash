#!/bin/bash

echo "The  following question refer to the domain bought from ovh"
read -p "What is your domain name : " domain_name
export DOMAIN_NAME=$domain_name

echo "Be careful the following names are already mandated by ovh : mail.$domain_name, smtp.$domain_name, pop3.$domain_name, imap.$domain_name"
read -p "What is your host name : " short_name
export SHORT_NAME=$short_name
host_name="$short_name.$domain_name"

# Install postfix
echo "postfix postfix/mailname string $domain_name" | debconf-set-selections
echo "postfix postfix/main_mailer_type string 'Internet Site'" | debconf-set-selections
apt-get -y install postfix mailutils > /dev/null

# Configure postfix
conf="/etc/postfix/main.cf"
sed -r 's/myhostname.*/myhostname = '$host_name'/' -i $conf
sed -r 's/mydestination.*/mydestination = $myhostname, '$short_name', localhost.localdomain, localhost/' -i $conf

# Modify /etc/hostname
conf="/etc/hostname"
hostname $host_name
echo $host_name > $conf

# Modify /etc/hosts
conf="/etc/hosts"
sed -r 's/127.0.1.1.*/127.0.1.1\t'$host_name'/' -i $conf
public_ip=`curl -s ident.me`
sed '/'$host_name'/a '$public_ip'\t'$host_name'' -i $conf

# Create DNS entries
apt -y install python3-pip >/dev/null
pip3 install ovh >/dev/null
python3 api.py
