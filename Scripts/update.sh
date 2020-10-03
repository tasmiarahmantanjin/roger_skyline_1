# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    update.sh                                          :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: trahman <trahman@student.hive.fi>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2020/09/30 18:51:48 by trahman           #+#    #+#              #
#    Updated: 2020/09/30 18:52:03 by trahman          ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

#!/bin/bash

printf "\n" >> /var/log/update_script.log
date >> /var/log/update_script.log

sudo apt-get update -y >> /var/log/update_script.log
sudo apt-get upgrade -y >> /var/log/update_script.log
