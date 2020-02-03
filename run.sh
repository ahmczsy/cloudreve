#!/bin/bash

rm -f /usr/local/bin/conf.yaml && sed -e "s#{CLOUDREVE_TOKEN}#${CLOUDREVE_TOKEN}#g;" /usr/local/bin/taskqueue-conf.tpl > /usr/local/bin/conf.yaml
rm -f /etc/aria2/aria2.conf && sed -e "s#{ARIA2_TOKEN}#${ARIA2_TOKEN}#g;" /etc/aria2/aria2-conf.tpl > /etc/aria2/aria2.conf

sudo -u www-data aria2c --conf-path=/etc/aria2/aria2.conf &
docker-php-entrypoint &
apache2-foreground &
sleep 5 && (taskqueue || true) &

while true
do
        sleep 15 && (curl http://localhost/Cron || true)
done
