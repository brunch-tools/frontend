#!/bin/bash

echo "####################################"
echo "Brunch Toolkit Installer (x64/amd64)"
echo "####################################"

if [ $(whoami) != 'root' ]; then
	echo "Please run with sudo or doas!"
	exit 1
fi

echo "Steps:"
echo "* Remove Previous Installation"
echo "* Download & Install New Version"
echo "* Restart Daemon"
echo "####################################"
echo "Uninstalling of previous versions will proceed in 5 seconds, please cancel to end."
sleep 5

# Begin to Mount
if [ -z "$EDITOR" ]; then EDITOR=nano; fi
	source=$(rootdev -d)
if (expr match "$source" ".*[0-9]$" >/dev/null); then
	partsource="$source"p
else
	partsource="$source"
fi
mkdir /tmp/brunch-mnt
mount "$partsource"7 /tmp/brunch-mnt

# Remove Old Versions
rm /tmp/brunch-mnt/patches/99-brunch_toolkit.sh
rm /usr/local/bin/brunch-toolkit-daemon
rm /etc/init/brunch-toolkit-daemon.conf

echo "Installation will proceed in 5 seconds, please cancel to end. If you cancel now, remove /tmp/brunch-mnt and /tmp/brunch-setup"
sleep 5

# Download New Version
mkdir /tmp/brunch-setup
curl -o /tmp/brunch-setup/99-brunch_toolkit.sh https://brunch.xeu100.com/brunch-toolkit-daemon/99-brunch_toolkit.sh
curl -o /tmp/brunch-setup/brunch-toolkit-daemon https://brunch.xeu100.com/brunch-toolkit-daemon/brunch-toolkit-daemon
curl -o /tmp/brunch-setup/brunch-toolkit-daemon.conf https://brunch.xeu100.com/brunch-toolkit-daemon/brunch-toolkit-daemon.conf

# Install New Version
mv /tmp/brunch-setup/99-brunch_toolkit.sh /tmp/brunch-mnt/patches/99-brunch_toolkit.sh
chown root:root /tmp/brunch-mnt/patches/99-brunch_toolkit.sh
chmod +x /tmp/brunch-mnt/patches/99-brunch_toolkit.sh
mv /tmp/brunch-setup/brunch-toolkit-daemon /usr/local/bin/brunch-toolkit-daemon
chmod +x /usr/local/bin/brunch-toolkit-daemon
mv /tmp/brunch-setup/brunch-toolkit-daemon.conf /etc/init/brunch-toolkit-daemon.conf
chown root:root /etc/init/brunch-toolkit-daemon.conf

echo "Unmounting & Clean Up will proceed in 5 seconds, please cancel to end. If you cancel now, remove /tmp/brunch-mnt and /tmp-brunch-setup"
sleep 5

# Clean Up
umount /tmp/brunch-mnt
rm -rf /tmp/brunch-setup
rm -rf /tmp/brunch-mnt

# Restart Service
initctl reload-configuration
initctl restart brunch-toolkit-daemon

echo "####################################"
echo "Welcome to Brunch Toolkit!"
echo "Please head back to the app!"
echo "####################################"