#! /bin/bash

VERSION=3.0

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

echo ${TGT_SCRIPT_NAME}
#-----------------------------------------------------------------------
# Crea copia a partir del generico como nuevo script
#-----------------------------------------------------------------------
cp -v ./back_a_rojo_gen.sh ${TGT_SCRIPT_NAME}
#-----------------------------------------------------------------------
# DIR_BASE="DIR_BASE_GEN"
#-----------------------------------------------------------------------
DIR_BASE=$(grep "DIR_BASE=" ./${CONFIG_FILE_NAME}| sed -r 's/DIR_BASE=\"(.*)\"/\1/' )
echo "DIR_BASE: " ${DIR_BASE}
sed -i -r -e "s%DIR_BASE_GEN%${DIR_BASE}%" ./${TGT_SCRIPT_NAME}
#-----------------------------------------------------------------------
# DIR_REDUC=${DIR_BASE}"DIR_REDUC_GEN"
#-----------------------------------------------------------------------
DIR_REDUC=$(grep "DIR_REDUC=" ./${CONFIG_FILE_NAME}| sed -r 's/DIR_REDUC=\"(.*)\"/\1/' )
echo "DIR_REDUC: " ${DIR_REDUC}
sed -i -r -e "s%DIR_REDUC_GEN%${DIR_REDUC}%" ./${TGT_SCRIPT_NAME}

#-----------------------------------------------------------------------
# DIR_DETALL=${DIR_BASE}"DIR_DETALL_GEN"
#-----------------------------------------------------------------------
DIR_DETALL=$(grep "DIR_DETALL=" ./${CONFIG_FILE_NAME}| sed -r 's/DIR_DETALL=\"(.*)\"/\1/' )
echo "DIR_DETALL: " ${DIR_DETALL}
sed -i -r -e "s%DIR_DETALL_GEN%${DIR_DETALL}%" ./${TGT_SCRIPT_NAME}

#-----------------------------------------------------------------------
# MOUNTED_ORIGIN_DIR_NAME="MOUNTED_ORIGIN_DIR_NAME_GEN"
#-----------------------------------------------------------------------
MOUNTED_ORIGIN_DIR_NAME=$(grep "MOUNTED_ORIGIN_DIR_NAME=" ./${CONFIG_FILE_NAME}| sed -r 's/MOUNTED_ORIGIN_DIR_NAME=\"(.*)\"/\1/' )
echo "MOUNTED_ORIGIN_DIR_NAME: " ${MOUNTED_ORIGIN_DIR_NAME}
sed -i -r -e "s%MOUNTED_ORIGIN_DIR_NAME_GEN%${MOUNTED_ORIGIN_DIR_NAME}%" ./${TGT_SCRIPT_NAME}

#-----------------------------------------------------------------------
# ORIGIN_DIR_NAME="${MOUNTED_ORIGIN_DIR_NAME}ORIGIN_DIR_NAME_GEN"
#-----------------------------------------------------------------------
ORIGIN_DIR_NAME=$(grep 'ORIGIN_DIR_NAME=' ./${CONFIG_FILE_NAME}| grep -v "MOUNTED" | sed -r 's/ORIGIN_DIR_NAME=\"(.*)\"/\1/' )
echo "ORIGIN_DIR_NAME: " ${ORIGIN_DIR_NAME}
sed -i -r -e "s%ORIGIN_DIR_NAME_GEN%${ORIGIN_DIR_NAME}%" ./${TGT_SCRIPT_NAME}

#-----------------------------------------------------------------------
# En dos pasos:
# MOUNTED_DEST_DIR_NAME="MOUNTED_DEST_DIR_NAME_GEN"
# 
# DEST_DIR_NAME="${MOUNTED_DEST_DIR_NAME}DEST_DIR_NAME_GEN"
#-----------------------------------------------------------------------

MOUNTED_DEST_DIR_NAME=$(grep 'MOUNTED_DEST_DIR_NAME=' ./${CONFIG_FILE_NAME}| sed -r 's/MOUNTED_DEST_DIR_NAME=\"(.*)\"/\1/' )
echo "MOUNTED_DEST_DIR_NAME: " ${MOUNTED_DEST_DIR_NAME}
sed -i -r -e "s%MOUNTED_DEST_DIR_NAME_GEN%${MOUNTED_DEST_DIR_NAME}%" ./${TGT_SCRIPT_NAME}

DEST_DIR_NAME=$(grep 'DEST_DIR_NAME=' ./${CONFIG_FILE_NAME}| grep -v "MOUNTED" | sed -r 's/DEST_DIR_NAME=\"(.*)\"/\1/' )
echo "DEST_DIR_NAME: " ${DEST_DIR_NAME}
sed -i -r -e "s%DEST_DIR_NAME_GEN%${DEST_DIR_NAME}%" ./${TGT_SCRIPT_NAME}
