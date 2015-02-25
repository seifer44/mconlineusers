#!/bin/bash
#
##############################################################
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program. If not, see <http://www.gnu.org/licenses/>.
#
##############################################################
#
#
#### Minecraft Log Parser for Users Online
#### Created by TimeLord410 on minecraftforum.net
#### Edited by Seifer44
#### https://github.com/seifer44/mconlineusers/
#### Original Script Location: http://www.minecraftforum.net/topic/1463424-gnerate-list-of-online-players-with-no-modding/

### Variables ###

#serverLog="Enter the path to your server.log file here"
#displayPage="Enter the location to the js, php, or html file you are using to display the online players"
#mcTemp="Enter a temporary file here. This is simply to store data before writing to the $displayPage"

serverLog="/home/minecraft/ramdisk/logs/latest.log"
displayPage="/var/www/mc/mconline/online.js"
mcTemp="/opt/minecraft/scripts/online.tmp"

#### The conditions of this while loop will cause the script to run in an unending loop. This is expected behavior.
#### It is recommended you install a utility like screen & run it from there.

while [ 1 ]

do
#### Edit this line for an alternate head of the output ####
        echo -n "var usersonline = \"" > $mcTemp

        getConnected=`netstat -n | grep 25565 | awk {'print $5'} | cut -d : -f5`

        for connected in $getConnected
        do

                loggedIn=`cat $serverLog | egrep ":$connected] logged in" | awk {'print $4'} | cut -d [ -f1`

                for players in $loggedIn
                do
                        sed -i "/$loggedIn/d" $displayPage
                        
                        #### Edit this line if you need it to be deliminated by something other than a space ####
                        echo -n "$loggedIn " >> $mcTemp
                done

        done

        getDisconnected=`cat $serverLog | tail -n 1 | egrep "left the game" | awk {'print $4'}`

        for disconnected in $getDisconnected
        do

                loggedOut=`echo $disconnected`

                for offline in $loggedOut
                do

                        sed -i "/$loggedOut/d" $displayPage

                done

        done

### Edit this line for the tail of the output ###
        echo -n "\";" >> $mcTemp
        cat $mcTemp > $displayPage

        sleep 1

done
