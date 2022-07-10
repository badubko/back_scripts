#! /bin/bash

VERSION=4.0

if [ $# -eq 0 ]
then 
 echo -e "No se indico nombre del config file...\n"
 exit
else
 if [ ! -f ${1} ]
 then
     echo -e "No existe el config file...${1} \n"
     exit
 fi
fi
CONFIG_FILE_NAME=${1}
#-----------------------------------------------------------------------
#   Obtener nombre del script de destino
#-----------------------------------------------------------------------
TGT_SCRIPT_NAME="./"$(grep "TGT_SCRIPT_NAME=" ./${CONFIG_FILE_NAME}| sed -r 's/TGT_SCRIPT_NAME=\"(.*)\"/\1/' )

echo "Target script name: " ${TGT_SCRIPT_NAME}

#-----------------------------------------------------------------------
# Crea script especifico a partir del generico, insertando el config
#-----------------------------------------------------------------------

INS_MARKER="INSERT_CONFIG_HERE"
sed "/${INS_MARKER}/r  ${CONFIG_FILE_NAME}" ./back_a_samba_gen.sh > ${TGT_SCRIPT_NAME}
