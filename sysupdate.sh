#!/usr/bin/bash

# TODO: answer yes automatically

logfile="sysupdate_"$(date +%F_%H:%M:%S)".log"
pacman -Syyu |& tee updates/$logfile

