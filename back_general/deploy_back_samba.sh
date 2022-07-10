#! /bin/bash
# 
# Deploy script for back_samba
# Version 2.6
# Version 2.8 Gets exclude file name from back_samba.sh
# Version 4.0 Adapted for generic script which generates specific script
#			  Should be improved (no harcoded names...)

VERSION="4.0"

# Should be run as root or sudo
# Check to be added later...

TARGET_SCRIPT="./back_samba.sh"

# Gets exclude file name from back_samba.sh. It's assumed that it resides in the same directory
# as the main script.

TARGET_EXCLUDE="./"$(grep "EXCLUDE_FILE_NAME_CFG=" ./back_samba.cfg| sed -r 's/EXCLUDE_FILE_NAME_CFG=\"(.*)\"/\1/' )

DEST_DIR="/opt/back_samba/"

cp --update --verbose ${TARGET_SCRIPT} ${TARGET_EXCLUDE} ${DEST_DIR}

chmod 755 ${DEST_DIR}$(basename ${TARGET_SCRIPT})
