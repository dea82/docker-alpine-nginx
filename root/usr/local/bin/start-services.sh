#!/bin/sh

USER="www"

KEYS_DIR="/keys"

DEPLOY_KEY_DIR="$KEYS_DIR/deploy_key"
DEPLOY_KEY_SOURCE="$DEPLOY_KEY_DIR/authorized_keys"
DEPLOY_KEY_DESTINATION="/home/$USER/.ssh/authorized_keys"

SIGN_KEY_DIR="$KEYS_DIR/sign_key"
SIGN_KEY_DEST_DIR="/www/.secret"

if [ ! -f $DEPLOY_KEY_SOURCE ]; then
   echo "ERROR: Deploy key $DEPLOY_KEY_SOURCE could not be found."
   exit 1
fi

cp $DEPLOY_KEY_SOURCE $DEPLOY_KEY_DESTINATION
chown $USER:$USER $DEPLOY_KEY_DESTINATION
chmod 0600 $DEPLOY_KEY_DESTINATION


sign_key_source="$(find $SIGN_KEY_DIR -name *.rsa | head -n1)"
if [ "$sign_key_source" = "" ]; then
    echo "ERROR: Sign key could not be found in directory $SIGN_KEY_DIR."
    exit 1
fi
sign_key_name="$(echo $sign_key_source | xargs basename)"
sign_key_source="$SIGN_KEY_DIR/$sign_key_name"
sign_key_destination="$SIGN_KEY_DEST_DIR/$sign_key_name"


mkdir -p $SIGN_KEY_DEST_DIR
chown $USER:$USER $SIGN_KEY_DEST_DIR
chmod 0700 $SIGN_KEY_DEST_DIR
cp $sign_key_source $sign_key_destination
chown $USER:$USER $sign_key_destination

#TODO: Add port as a parameter - environment variable when building image?
/usr/sbin/sshd -p 6223
nginx
