#! /bin/bash
# 
# Deploy script for back_samba
# Version 2.6
# Version 2.8 Gets exclude file name from back_samba.sh

VERSION="2.8"

# Should be run as root or sudo
# Check to be added later...

TARGET_SCRIPT="./back_samba.sh"

TARGET_EXCLUDE="./"$(grep "EXCLUDE_FILE_NAME=" ./back_samba.sh| sed -r 's/EXCLUDE_FILE_NAME=\"(.*)\"/\1/' )

DEST_DIR="/opt/back_samba/"

cp --update --verbose ${TARGET_SCRIPT} ${TARGET_EXCLUDE} ${DEST_DIR}

chmod 755 ${DEST_DIR}$(basename ${TARGET_SCRIPT})
