#!/bin/bash

# Step 1 - Run this script to setup vmware-tools installation
# Step 2 - Run vmware-tools installer


# Create dirs
sudo mkdir -pv /etc/init.d
for i in {0..6}; do sudo mkdir -pv /etc/init.d/rc${i}.d; done

# Install dependencies
sudo pacman -S --needed --noconfirm base-devel net-tools 
sudo pacman -S yaourt --needed --noconfirm
yaourt -S vmware-systemd-services --needed --noconfirm


if [ ! -f /etc/systemd/system/vmware.service ] || [ ! -f /etc/systemd/system/vmware-usbarbitrator.service ]; then 
	
	mkdir -pv ~/.vmwaretemp

cat <<EOT >> /home/$USER/.vmwaretemp/vmware.service
[Unit]
Description=VMware daemon
Requires=vmware-usbarbitrator.service
Before=vmware-usbarbitrator.service
After=network.target

[Service]
ExecStart=/etc/init.d/vmware-tools start
ExecStop=/etc/init.d/vmware-tools stop
PIDFile=/var/lock/subsys/vmware
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
EOT

cat <<EOT >> /home/$USER/.vmwaretemp/vmware-usbarbitrator.service
[Unit]
Description=VMware USB Arbitrator
Requires=vmware-tools.service
After=vmware-tools.service

[Service]
ExecStart=/usr/bin/vmware-usbarbitrator
ExecStop=/usr/bin/vmware-usbarbitrator –kill
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
EOT

	cd ~/.vmwaretemp && sudo mv vmware.service vmware-usbarbitrator.service /etc/systemd/system/
	rm -rf ~/.vmwaretemp

fi