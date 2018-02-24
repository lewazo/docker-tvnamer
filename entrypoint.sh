#!/bin/sh

USER_ID=${PUID:-9001}
GROUP_ID=${PGID:-9001}
PERSISTENT_CONFIG_FILE=/config/tvnamer.json

echo "Using UID: $USER_ID"
echo "Using GID: $GROUP_ID"

if ! getent group $GROUP_ID > /dev/null 2>&1; then
    addgroup -g $GROUP_ID abc
fi

if ! getent passwd $USER_ID > /dev/null 2>&1; then
    adduser -D -u $USER_ID abc
fi

GROUP_NAME="$(getent group $GROUP_ID | cut -d: -f1)"
USER_NAME="$(getent passwd $USER_ID | cut -d: -f1)"

usermod -g $GROUP_NAME $USER_NAME

if [ ! -f $PERSISTENT_CONFIG_FILE ]; then
    tvnamer --save=$PERSISTENT_CONFIG_FILE
    chown $USER_ID $PERSISTENT_CONFIG_FILE
    chown $GROUP_ID $PERSISTENT_CONFIG_FILE
fi

ln -sf $PERSISTENT_CONFIG_FILE /home/abc/.tvnamer.json

exec /sbin/su-exec $USER_ID "$@"
