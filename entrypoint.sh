#!/bin/sh

USER_ID=${PUID:-9001}
GROUP_ID=${PGID:-9001}
PERSISTENT_CONFIG_FILE=/config/tvnamer.json

echo "Using UID : $USER_ID"
echo "Using GID : $GROUP_ID"

addgroup -g $GROUP_ID abc
adduser -D -u $USER_ID -G abc abc

if [ ! -f $PERSISTENT_CONFIG_FILE ]; then
    tvnamer --save=$PERSISTENT_CONFIG_FILE
    chown $USER_ID $PERSISTENT_CONFIG_FILE
    chown $GROUP_ID $PERSISTENT_CONFIG_FILE
fi

ln -sf $PERSISTENT_CONFIG_FILE /home/abc/.tvnamer.json

exec /sbin/su-exec $USER_ID "$@"
