#!/bin/bash
SERVICES="ssh apache2 mysql"
DATE=$(date '+%d-%m-%Y %H:%M:%S')

for SERVICE in ${SERVICES}
 do
   /usr/sbin/service $SERVICE status 2>&1>/dev/null
    if [ $? -ne 0 ];
      then
        /usr/sbin/service $SERVICE restart
        echo -e "Starting $SERVICE"
        (echo "Subject:Restarting $SERVICE"; echo "$DATE $SERVICE is not running on $HOSTNAME! Restarting!";) | /usr/sbin/sendmail webmaster@kittelson.com
      else
        echo -e "$SERVICE OK"
    fi
done
