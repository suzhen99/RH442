#!/bin/bash

EX442_TOOLS=~kiosk/Desktop/Packages

if [ ! -d $EX442_TOOLS ]; then
  echo "Please put Packages folder on ~kiosk/Desktop"; break; exit 442
fi
source $EX442_TOOLS/labtool.shlib
chmod +x $EX442_TOOLS/bin/* $EX442_TOOLS/root/{ca*,hu*}

if [ "$(hostname)" == "foundation0.ilt.example.com" ]; then
  if grep -q mem.*2097152 /content/rhel7.0/x86_64/vms/rh442-server.xml; then
    sed -i.origin 's/2097152/4194304/' /content/rhel7.0/x86_64/vms/rh442-server.xml
  fi
  echo y | rht-vmctl fullreset classroom
  wait_online classroom
fi

KVM_SX=s$(hostname | grep -o [[:digit:]])
echo y | rht-vmctl fullreset server
wait_online $KVM_SX
rsync $EX442_TOOLS/root/* root@${KVM_SX}:~
rsync $EX442_TOOLS/bin/* root@${KVM_SX}:/usr/local/bin
ssh root@${KVM_SX} 'ex442_setup.sh'
