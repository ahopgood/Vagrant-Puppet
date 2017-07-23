#! /bin/usr/bash

#echo "About to call pkill"
#/usr/bin/pkill -f jekyll
#echo "pkill done"
#$(/bin/ps -aux | /bin/grep jekyll | /bin/grep -v grep)

ps -aux | grep jekyll | grep -v grep | awk '{ print $2 }' | xargs kill
exit(0)
#PID=$(ps -aux | grep jekyll | grep -v grep | awk '{ print $2 }' )

#echo "PID found:"$PID
#echo $PID
#echo "jekyll found still running[1-no|0-yes]?:"$?
