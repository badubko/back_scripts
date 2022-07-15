#! /bin/bash
# 
# Deploy script for back_samba
# Version 2.6
# Version 2.8 Gets exclude file name from back_samba.sh
# Version 4.0 Adapted for generic script which generates specific script
#			  Should be improved (no harcoded names...)
# Version 5.0 Now this is a general purpouse script: it will deploy the back-up
#			  scipt itself and the exclude file getting the
# 			  information from the config file passed as an argument
# Version 5.2

if [ ${EUID} != 0  ]
then
  echo "Should be run as root..."
  exit
fi
  
# Import function

. ./check_config_file.sh

VERSION=5.2

CONFIG_FILE_NAME=${1}
N_ARGS=${#}

check_config_file 

# Gets exclude file name from back_samba.sh. It's assumed that it resides in the same directory
# as the main script.

# TARGET_EXCLUDE="./"$(grep "EXCLUDE_FILE_NAME_CFG=" ./back_samba.cfg| sed -r 's/EXCLUDE_FILE_NAME_CFG=\"(.*)\"/\1/' )

# Now we get all parameters from the config file

. ./${CONFIG_FILE_NAME}

DEPLOY_DESTINATION_DIR=${DEPLOY_DESTINATION_DIR_CFG}

EXCLUDE_FILE_NAME=${EXCLUDE_FILE_NAME_CFG}

# Solucion transitoria para evitar que se pisen los archivos en caso de que no
# exista el deploy destination dir

cp --update --verbose ${TGT_SCRIPT_NAME}   ${DEPLOY_DESTINATION_DIR}
cp --update --verbose ${EXCLUDE_FILE_NAME} ${DEPLOY_DESTINATION_DIR}

chmod 755 ${DEPLOY_DESTINATION_DIR}$(basename ${TGT_SCRIPT_NAME})
