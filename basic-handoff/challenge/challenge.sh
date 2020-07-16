#!/bin/bash

echo "$FLAG" > /var/www/html/flag.html
/usr/sbin/apache2ctl -k start
echo "Please navigate to http://$SERVICE_HOST:$SERVICE_PORT/ in your favorite browser."
if [ -z $TIMEOUT ]; then
    echo "You have 60 seconds."
    sleep 60
else
    echo "You have $TIMEOUT seconds."
    sleep $TIMEOUT
fi

