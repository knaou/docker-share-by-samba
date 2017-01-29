#!/bin/sh

# Option
if [ "$WORKGROUP" == "" ]; then
  WORKGROUP=WORKGROUP
fi
if [ "$USER_ID" == "" ]; then
  USER_ID=1000
fi
if [ "$USER_NAME" == "" ]; then
  USER_NAME=samba
fi
if [ "$PASSWORD" == "" ]; then
  PASSWORD=samba
fi
if [ "$SHARE_NAME" == "" ]; then
  SHARE_NAME=share
fi
if [ "$SHARE_DIR" == "" ]; then
  SHARE_DIR=/share
fi

create_smb_conf(){ 
if [ ! -e /etc/samba/smb.conf ]; then
(cat <<-EOF
[global]
workgroup = $WORKGLOUP
dos charset = cp850
unix charset = UTF8
[$SHARE_NAME]
browseable = yes
writeable = yes
path = $SHARE_DIR
EOF
) > /etc/samba/smb.conf
fi
}

create_user(){
adduser -u $USER_ID $USER_NAME <<-EOF
$PASSWORD
$PASSWORD
EOF
smbpasswd -a -s $USER_NAME <<-EOF
$PASSWORD
$PASSWORD
EOF
}
prepare_directory(){
  if [ -e $SHARE_DIR ]; then
    mkdir $SHARE_DIR
    chmod 0755 $SHARE_DIR
    chown $USER_NAME:$USER_NAME $SHARE_DIR
  fi
}

echo "Create samba configuration"
create_smb_conf > /dev/null 2> /dev/null
echo "Create samba user"
create_user > /dev/null 2> /dev/null
echo "Prepare directory"
prepare_directory > /dev/null 2> /dev/null

exit_smbd(){
  kill `cat /var/run/samba/smbd.pid`
  kill `cat /var/run/samba/nmbd.pid`
  exit
}

trap "exit_smbd" SIGTERM SIGINT

echo "Up smbd daemon"
echo "WORKGROUP=$WORKGROUP"
echo "USER_ID=$USER_ID"
echo "USER_NAME=$USER_NAME"
echo "PASSWORD=<secret>"
echo "SHARE_NAME=$SHARE_NAME"
echo "SHARE_DIR=$SHARE_DIR"

/usr/sbin/smbd -D
tail -f /var/log/samba/log.smbd

