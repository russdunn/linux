#! /bin/sh

upSeconds=`/usr/bin/cut -d. -f1 /proc/uptime`
secs=$(($upSeconds%60))
mins=$(($upSeconds/60%60))
hours=$(($upSeconds/3600%24))
days=$(($upSeconds/86400))
UPTIME=`printf "%d days, %02dh %02dm %02ds " "$days" "$hours" "$mins" "$secs"`

echo "\033[0;34m
       DENMOR                 \033[0;37m`date +"%A, %e %B %Y, %R"`\033[0;34m
     AUTOMOTIVE               \033[0;37m`uname -srmo`\033[0;36m
      WORKSHOP                \033[0;37m\033[0;36m
       SERVER                 \033[0;37mUptime.............: $UPTIME\033[0;31m
  ---------------             \033[0;37mMemory.............: $((`cat /proc/meminfo | grep MemFree | awk {'print $2'$
Unauthorised Access           \033[0;37mRunning Processes..: `ps ax | wc -l | tr -d " "`\033[0;31m
 Will Be Prosocuted           \033[0;37m\033[0;31m
 To The Full Extent           \033[0;37mIP Addresses.......: `/sbin/ifconfig | /bin/grep "Bcast:" | /usr/bin/cut -d$
 Of Applicable Law.           \033[0;37mTemperature........: `vcgencmd measure_temp | sed "s/temp=//"`\033[0;31m
   ==> Too Late               \033[0;37m" > /etc/motd
