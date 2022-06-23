#! /bin/bash
# Version 2.6
# Deploy script for back_samba
# 
VERSION="2.6"

# Should be run as root or sudo
# Check to be added later...
# See you later, aligator...
# It would be nice to get the exclude... file name from the back_samba.sh
# wouldla & shouldla....

TARGET_SCRIPT="./back_samba.sh"
TARGET_EXCLUDE="./exclude_patterns_file.txt"

DEST_DIR="/opt/back_samba/"

cp --update --verbose ${TARGET_SCRIPT} ${TARGET_EXCLUDE} ${DEST_DIR}

chmod 755 ${DEST_DIR}$(basename ${TARGET_SCRIPT})
