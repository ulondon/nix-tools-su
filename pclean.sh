#!/usr/bin/bash

cache='/var/cache/pacman/pkg'
test_num=0
keep=1
kernel_keep=10
kernel=false

## opts
while [ $# -gt 0 ]; do
  case "$1" in
    -t|--test)
      shift
      if [ $# -gt 0 ]; then
        test_num=$1
      else
        echo "no test number specified"
        exit 1
      fi
      shift
      ;;
    -k|--keep)
      shift
      if [ $# -gt 0 ]; then
        keep=$1
      else
        echo "no keep number specified"
        exit 1
      fi
      shift
      ;;
    -z|--kernel-keep)
      shift
      if [ $# -gt 0 ]; then
        kernel_keep=$1
      else
        echo "no keep number specified"
        exit 1
      fi
      shift
      ;;
    -K|--kernel)
      kernel=true
      shift
      ;;
  esac
done

update_packs() {
  installed=$(ls $cache | awk -F '-[0-9]' '{print $1}' | sort | uniq)
  ins_kernel=$(echo "$installed" | grep -Px "^linux(?:-headers)?")
  ins_nonkernel=$(echo "$installed" | grep -Pvx "^linux(?:-headers)?")
}

update_packs

if [ $test_num -gt 0 ]; then
  pack=$(echo $installed | awk -v idx=$test_num '{print $idx}')
  printf "pack:\n$pack\n---\n\n"

  pfiles=$(ls $cache | awk -F '-[0-9]' -v p=$pack '($1 == p) {print}' | sort -V)
  printf "pack files:\n$pfiles\n---\n"

  # allver=$(echo "$pfiles" | awk -F '-' '{printf "%s-%02d\n", $2, $3}' | sort)
  allver=$(echo "$pfiles" | sed "s/$pack-//" | sed 's/.pkg.*$//' | sort -V)
  oldver=$(echo "$allver" | head -n -$keep)
  latest=$(echo "$allver" | tail -n $keep)

  printf "all versions:\n$allver\n---\n"
  printf "old versions:\n$oldver\n---\n"
  printf "latest versions:\n$latest\n---\n"
  exit 0
fi

if $kernel ; then
  # all files except linux and linux-headers
  nonkernel=$(ls $cache | grep -P -v "^linux(?:-headers)?(?=-[0-9])")
  read -p 'delete all non-kernel packs (y/n)? ' yes
  [ $yes == "y" ] && rm  $nonkernel
  update_packs
fi

for p in $ins_kernel; do
  pfiles=$(ls $cache | awk -F '-[0-9]' -v p=$p '($1 == p) {print}' | sort -V)
  old=$(echo "$pfiles" | head -n -$kernel_keep)
  old=$(echo "$old" | awk -v dir=$cache '{print dir"/"$0}')
  echo "removing $p files..."
  rm $old
done

for p in $ins_nonkernel; do
  pfiles=$(ls $cache | awk -F '-[0-9]' -v p=$p '($1 == p) {print}' | sort -V)
  old=$(echo "$pfiles" | head -n -$keep)
  old=$(echo "$old" | awk -v dir=$cache '{print dir"/"$0}')
  echo "removing $p files..."
  rm $old
done
