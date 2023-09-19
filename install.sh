#! /bin/bash


find . ! -user "root" -print0 | xargs -0 --no-run-if-empty chown root
find . ! -group "root" -print0 | xargs -0 --no-run-if-empty chgrp -v root

ps -A | grep systemd > /dev/null
if [ "$?" = 0 ]; then
  SYSTEMD=1;
else
  SYSTEMD=0;
fi
cp auto-restart-openvpn /usr/bin/auto-restart-openvpn
if ! [ -f /etc/auto-restart-openvpn.conf ]; then
   cp auto-restart-openvpn.conf /etc/auto-restart-openvpn.conf
fi

if [[ "$SYSTEMD" = "1" ]]; then
  cp auto-restart-openvpn.service /usr/lib/systemd/system/auto-restart-openvpn.service
  cp auto-restart-openvpn.timer /usr/lib/systemd/system/auto-restart-openvpn.timer
  systemctl enable auto-restart-openvpn.timer
  systemctl restart auto-restart-openvpn.timer
  systemctl daemon-reload
else
  cp auto-restart-openvpn.crontab /etc/cron.d/auto-restart-openvpn
fi

if ! [ -d "/usr/share/sounds/auto-restart-openvpn" ]; then
   mkdir "/usr/share/sounds/auto-restart-openvpn"
fi

cp -R sounds/* "/usr/share/sounds/auto-restart-openvpn"

install -m750  beep/beep_fall.sh          /bin/beep_fall.sh
install -m750  beep/beep_victory.sh       /bin/beep_victory.sh
install -m750  beep/beep_mario-victory.sh /bin/beep_mario-victory.sh
install -m750  beep/beep_alarm.sh         /bin/beep_alarm.sh
install -m750  beep/beep_ring.sh          /bin/beep_ring.sh
