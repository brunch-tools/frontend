#!/bin/bash

echo "##################################"
echo "Brunch Tools Installer (x64/amd64)"
echo "##################################"

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
rm /tmp/brunch-mnt/patches/99-brunch_tools.sh
rm /usr/local/bin/brunch-tools-daemon
rm /etc/init/brunch-tools-daemon.conf

echo "Installation will proceed in 5 seconds, please cancel to end. If you cancel now, remove /tmp/brunch-mnt and /tmp/brunch-setup"
sleep 5

# Download New Version
LATEST_RELEASE=$(curl -L -s -H 'Accept: application/json' https://github.com/brunch-tools/daemon/releases/latest)
LATEST_VERSION=$(echo $LATEST_RELEASE | sed -e 's/.*"tag_name":"\([^"]*\)".*/\1/')
ARTIFACT_URL="https://github.com/brunch-tools/daemon/releases/download/$LATEST_VERSION/brunch-tools-daemon"
mkdir /tmp/brunch-setup
curl -o /tmp/brunch-setup/99-brunch_tools.sh https://brunch.tools/required/99-brunch_tools.sh
curl -L $ARTIFACT_URL > /tmp/brunch-setup/brunch-tools-daemon
curl -o /tmp/brunch-setup/brunch-tools-daemon.conf https://brunch.tools/required/brunch-tools-daemon.conf

# Install New Version
mv /tmp/brunch-setup/99-brunch_tools.sh /tmp/brunch-mnt/patches/99-brunch_tools.sh
chown root:root /tmp/brunch-mnt/patches/99-brunch_tools.sh
chmod +x /tmp/brunch-mnt/patches/99-brunch_tools.sh
mv /tmp/brunch-setup/brunch-tools-daemon /usr/local/bin/brunch-tools-daemon
chmod +x /usr/local/bin/brunch-tools-daemon
mv /tmp/brunch-setup/brunch-tools-daemon.conf /etc/init/brunch-tools-daemon.conf
chown root:root /etc/init/brunch-tools-daemon.conf

echo "Unmounting & Clean Up will proceed in 5 seconds, please cancel to end. If you cancel now, remove /tmp/brunch-mnt and /tmp-brunch-setup"
sleep 5

# Clean Up
umount /tmp/brunch-mnt
rm -rf /tmp/brunch-setup
rm -rf /tmp/brunch-mnt

# Restart Service
initctl reload-configuration
initctl restart brunch-tools-daemon
initctl start brunch-tools-daemon

echo "####################################"
echo "Welcome to Brunch Tools!"
echo "Please head back to the app!"
echo "####################################"
