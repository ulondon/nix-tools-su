#!/usr/bin/bash

# TODO: if conf file does not exist list available files
# TODO: smarter way to get interface name

iface=$(ip link | grep -P "(wlp|wlan)" | awk '{print $2}' | sed 's/://')
mtu=1492

if [ "$1" == "-d" ]; then
  dhcpcd -k $iface
  killall wpa_supplicant
  # pid=$(ps aux | grep wpa_supplicant | grep -v grep | awk '{print $2}')
  # kill $pid
  exit 0
fi

if [ "$1" == "-l" ]; then
  ls /etc/wpa_supplicant | sed 's/\.conf//'
  exit 0
fi

conf=/etc/wpa_supplicant/vered.conf
if [ $# -gt 0 ]; then
  conf=/etc/wpa_supplicant/$1.conf
fi

ip link set dev $iface mtu $mtu
wpa_supplicant -B -i $iface -c $conf && dhcpcd $iface
