#!/usr/bin/bash

if [ "$1" == "-d" ]; then
  systemctl stop dhcpcd@wlp1s0
  systemctl stop wpa_supplicant@wlp1s0.service
  exit 0
fi

systemctl start wpa_supplicant@wlp1s0.service
systemctl start dhcpcd@wlp1s0
