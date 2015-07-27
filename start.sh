#! /bin/sh

cp -n /etc/syncthing/config.xml /syncthing/config.xml
sudo unlink /var/run/supervisor.sock
supervisord -n
