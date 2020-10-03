# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    cron_monitor.sh                                    :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: trahman <trahman@student.hive.fi>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2020/09/30 18:52:45 by trahman           #+#    #+#              #
#    Updated: 2020/09/30 18:54:16 by trahman          ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

#!/bin/bash

FILE="/home/tasmia/crontab_monitor"
FILE_TO_WATCH="/etc/crontab"
MD5VALUE=$(sudo md5sum $FILE_TO_WATCH)

if [ ! -f $FILE ]
then
		echo "$MD5VALUE" > $FILE
		exit 0;
fi;
		echo "$MD5VALUE"
		cat $FILE

if [ "$MD5VALUE" != "$(cat $FILE)" ];
		then
		echo "$MD5VALUE" > $FILE
		echo "$FILE_TO_WATCH has been modified ! '*_*" | mail -s "$FILE_TO_WATCH modified !" root
fi;
