#!/bin/bash
#
# this script runs nodejs on master.js
# after that process exits, this script waits 60 seconds and retries

# before trying to use them, update any attached funcubes to use the 48 kHz firmware
# this can be prevented by including the string "NO_AUTO_FCD_UPDATE" somewhere in
# the deployment.txt file

if ! grep -q NO_AUTO_FCD_UPDATE /data/sg_files/deployment.txt; then
    /home/pi/proj/sensorgnome/scripts/update_fcd_firmware
fi

# do not connect to motus backend via ssh tunnel
# /home/pi/proj/sensorgnome/scripts/maintain_ssh_tunnel

cd /home/pi/proj/sensorgnome/master
export NODE_ENV=production VAMP_PATH=/home/pi/.vamp NODE_PATH=/home/pi/proj/sensorgnome/master/node_modules LC_ALL="C.UTF-8"
for (( ; ; )) do
nice -n -15 /usr/bin/nodejs ./master.js > /var/log/nodelog.txt 2>&1
killall -KILL rtl_tcp vamp-alsa-host 
sleep 60
done
