#! /bin/bash
# xformer == trans-former
# 
# Version 5.0 Genera a partir del script generico, un script de backup especifico, 
#             tomando los parametros del config file pasado como argumento.
#
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

# echo ${CONFIG_FILE_NAME} ; exit

#-----------------------------------------------------------------------
#   Obtener nombre del script de destino
#-----------------------------------------------------------------------
# TGT_SCRIPT_NAME="./"$(grep "TGT_SCRIPT_NAME=" ./${CONFIG_FILE_NAME}| sed -r 's/TGT_SCRIPT_NAME=\"(.*)\"/\1/' )

# En vez de usar el metodo "elegante" de mas arriba, importamos directamente el config file
# en el cual estan definidos los valores de las variables.

. ./${CONFIG_FILE_NAME}

echo "Target script name: " ${TGT_SCRIPT_NAME}

#-----------------------------------------------------------------------
# Crea script especifico a partir del generico, insertando el config
#-----------------------------------------------------------------------

INS_MARKER="INSERT_CONFIG_HERE"
sed "/${INS_MARKER}/r  ${CONFIG_FILE_NAME}" ./back_generico.sh > ${TGT_SCRIPT_NAME}
