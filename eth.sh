#!/usr/bin/bash

iface=$(ip link | grep -v "link/" | grep -P "(enp|eth)" | awk '{print $2}' | sed 's/://')
mtu=1492

if [ "$1" == "-d" ]; then
  dhcpcd -k $iface
  ip link set dev $iface down
  exit 0
fi

ip link set dev $iface mtu $mtu
ip link set dev $iface up
dhcpcd $iface
