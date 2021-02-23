cat >/roota/etc/init/brunch-toolkit-daemon.conf <<EOF
# The Brunch Toolkit Daemon
# By xeu100 for Wisteria's Brunch Toolkit

description	"Summon a web socket daemon for use with the BT GUI"
author		"me@xeu100.com"

start on starting login
stop on starting logout

exec /usr/local/bin/brunch-toolkit-daemon
EOF
exit 0