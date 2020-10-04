#!/usr/bin/bash

shell='bash'
sfile=$1'.sh'
if [ "$EUID" -gt "0" ]; then
  pers=755
else
  pers=744
fi

echo '#!'$(which $shell) > $sfile
chmod $pers $sfile
