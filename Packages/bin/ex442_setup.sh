#!/bin/bash

echo -e ' INFO:\tGenerating sar file'
for i in {1..20}; do
  /usr/lib64/sa/sa1 1 1
  sleep 5
done

echo -e ' INFO:\tCreating user memhog'
useradd memhog

echo -e ' INFO:\tCreating swap partition'
echo -e 'n\n\n\n\n+512M\nt\n82\nw\n' | fdisk /dev/vdb &>/dev/null
mkswap /dev/vdb1 &>/dev/null
echo /dev/vdb1 none swap defaults 0 0 >> /etc/fstab
swapon -a

echo -e ' INFO:\tSetting elevator to cfq'
echo -e '\n[disk]\nelevator=cfq' >> /usr/lib/tuned/virtual-guest/tuned.conf
tuned-adm profile virtual-guest &>/dev/null

echo -e ' INFO:\tGenerating file sampleserver'
tar -xf sampleserver.tgz
rm -rf sampleserver.tgz
