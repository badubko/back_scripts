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

VERSION=5.0

CONFIG_FILE_NAME=${1}

if [ $# -eq 0 ]
then 
 echo -e "No se proporciono el nombre del config file..."
 echo -e "Usage: $0 <config_file_name.cfg \n"
 exit
else
 if [ "${CONFIG_FILE_NAME##*.}" != "cfg" ]
 then
     echo -e "El archivo no es del tipo .cfg (config file)...${CONFIG_FILE_NAME} \n"
     exit
 else
	 if [ ! -f ${CONFIG_FILE_NAME} ]
	 then
	     echo -e "No existe el config file...${CONFIG_FILE_NAME} \n"
	     exit
	 fi
 fi
fi

# Should be run as root or sudo
# Check to be added later...


# Gets exclude file name from back_samba.sh. It's assumed that it resides in the same directory
# as the main script.

# TARGET_EXCLUDE="./"$(grep "EXCLUDE_FILE_NAME_CFG=" ./back_samba.cfg| sed -r 's/EXCLUDE_FILE_NAME_CFG=\"(.*)\"/\1/' )

# Now we get all parameters from the config file

. ./${CONFIG_FILE_NAME}

DEPLOY_DESTINATION_DIR=${DEPLOY_DESTINATION_DIR_CFG}

EXCLUDE_FILE_NAME=${EXCLUDE_FILE_NAME_CFG}

echo cp --update --verbose ${TGT_SCRIPT_NAME} ${EXCLUDE_FILE_NAME} ${DEPLOY_DESTINATION_DIR}

echo chmod 755 ${DEPLOY_DESTINATION_DIR}$(basename ${TGT_SCRIPT_NAME})
