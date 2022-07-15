#! /bin/bash
# xformer == trans-former
# 
# Version 5.0 Genera a partir del script generico, un script de backup especifico, 
#             tomando los parametros del config file pasado como argumento.
# Version 5.2 Separada la funcion check_config_file.

# Import function

. ./check_config_file.sh

VERSION=5.2

CONFIG_FILE_NAME=${1}
N_ARGS=${#}
GENERIC_SCRIPT_NAME="./back_generico.sh"

check_config_file 


# echo ${CONFIG_FILE_NAME} ; exit

#-----------------------------------------------------------------------
#   Obtener nombre del script de destino
#-----------------------------------------------------------------------
# TGT_SCRIPT_NAME="./"$(grep "TGT_SCRIPT_NAME=" ./${CONFIG_FILE_NAME}| sed -r 's/TGT_SCRIPT_NAME=\"(.*)\"/\1/' )

# En vez de usar el metodo "elegante" de mas arriba, importamos directamente el config file
# en el cual estan definidos los valores de las variables.

. ./${CONFIG_FILE_NAME}

#-----------------------------------------------------------------------
# Crea script especifico a partir del generico, insertando el config
#-----------------------------------------------------------------------

INS_MARKER="INSERT_CONFIG_HERE"
sed "/${INS_MARKER}/r  ${CONFIG_FILE_NAME}" ${GENERIC_SCRIPT_NAME} > ${TGT_SCRIPT_NAME}

if [ $? = 0 ]
then
     echo "Created Target script name: " ${TGT_SCRIPT_NAME}
else
     echo "Failed to create: " ${TGT_SCRIPT_NAME}
fi      
