cat >/roota/etc/init/brunch-tools-daemon.conf <<EOF
# The Brunch Tools Daemon
# By xeu100 for Wisteria's Brunch Toolkit

description	"Summon a web socket daemon for use with the BT GUI"
author		"me@xeu100.com"

start on starting login
stop on starting logout

exec /usr/local/bin/brunch-tools-daemon
EOF
exit 0