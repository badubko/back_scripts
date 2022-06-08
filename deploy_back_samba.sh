#! /bin/bash
# Version 1.2
# Deploy script for back_samba
# 

# Should be run as root or sudo
# Check to be added later...
# See you later, aligator...

TARGET_SCRIPT="./back_samba_V1.2.sh"
DEST_DIR="/opt/back_samba/"

cp --update --verbose ${TARGET_SCRIPT} ${DEST_DIR}

chmod 755 ${DEST_DIR}$(basename ${TARGET_SCRIPT})
