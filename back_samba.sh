#! /bin/bash
# Version 1.1 2022.06.07
# Version 1.2 2022.06.07 Agregado determinacion de RUN_TYPE del run string
# Version 2.0 2022.06.08 Agregada variable VERSION con numero de version
# Version 2.1 2022.06.08 Agregada variables PROGRESS 
# Definir tipo de ejecucion del rsync

VERSION="2.1"

DRY="-n"
REAL=""

PROGRESS_YES="--progress"
PROGRESS_NO=""
PROGRESS=${PROGRESS_NO}


if [ $# -eq 0 ]
then 
 RUN_TYPE="${DRY}"
else
 case "${1,,}" in
 -dry | -d | --dry)
			RUN_TYPE="${DRY}"
  ;;
 -real | -r | --real )
			RUN_TYPE="${REAL}"
  ;;
  *)
  # Es otro string. que sea DRY
  RUN_TYPE="${DRY}"
 esac	

fi


# Verificar si los directorios origen y destino estan montados
# en ambos estan creados archivos vacios que sirven de marca
# para determinar si estan montados.

# 
#                 Origen CON /           (por ahora no....)
# ORIGIN_DIR_NAME="/samba/"
# ORIGIN_DIR_NAME="/media/badubko/badubko-q/Back_F/BAS/DOCS/PS_Adv"
ORIGIN_DIR_NAME="/samba/badubko-q/Back_F/BAS/Pagos"

#                 Destino SIN /                   v
# DEST_DIR_NAME="/samba_back"
DEST_DIR_NAME="/samba_0"

ORIGIN_MARK_NAME="${ORIGIN_DIR_NAME}/.ORIGIN_MARK"
DEST_MARK_NAME="${DEST_DIR_NAME}/.DEST_MARK"

if [ ! -f "${ORIGIN_MARK_NAME}" ]
then
  echo "$0: No esta montado el directorio origen ${ORIGIN_DIR_NAME} ${ORIGIN_MARK_NAME}"
  exit
fi

if [ ! -f "${DEST_MARK_NAME}" ]
then
  echo "$0: No esta montado el directorio destino ${DEST_DIR_NAME} ${DEST_MARK_NAME}"
  exit
fi

#------------------------------------------------------------------------------------------------

# Verificar si los directorios de log estan accesibles

# Directorios logs
DIR_BASE="/var/log/back_samba/"

# Verificar existencia de directorio base de logs
# Esto deberia escribir el mens de error en otro directorio...
if [ ! -d "${DIR_BASE}" ]
then
  echo "$0: No existe $DIR_BASE"
  exit
fi

# En el directorio DIR_REDUC se van escribiendo todos los logs reducidos
DIR_REDUC=${DIR_BASE}"back_samba_reduc"

# Verificar existencia de directorio de logs reducidos
# Esto deberia escribir el mens de error en otro directorio...
if [ ! -d "${DIR_REDUC}" ]
then
  echo "$0: No existe ${DIR_REDUC}"
  exit
fi

# En el directorio DIR_DETALL se van creando subdirs por dia y se va escribiendo los logs detallados
# correspondientes a cada dia
DIR_DETALL=${DIR_BASE}"back_samba_detalle"
SUB_DIR_DETALL_DATE="${DIR_DETALL}/$(date  +%Y-%m-%d)"

# Verificar existencia de directorio de logs de detalle
# Esto deberia escribir el mens de error en otro directorio...
if [ ! -d "${DIR_DETALL}" ]
then
  echo "$0: No existe ${DIR_DETALL}"
  exit
fi

if [ ! -d "${SUB_DIR_DETALL_DATE}" ]
then
  echo "$0: No existe ${SUB_DIR_DETALL_DATE}"
  mkdir  ${SUB_DIR_DETALL_DATE}
 fi


# Establecer fecha y hora de comienzo ejecucion
# RUN_DATE Fecha y hora de la ejecucion del script

START_TIME="$(date  +%Y-%m-%d_%H\:%M\:%S)"

# Reporte reducido se va generando por dia un archivo 
# cuyo nombre es AA-MM-DD_Rep_reduc_dia.log
# en este se va agregando el time stamp (ddmmaa_hhmm) del comienzo, el status fin y el time stamp fin
# de cada ejecucion del respaldo

FILE_NAME_REP_REDUC_DIA="${DIR_REDUC}/""$(date  +%Y-%m-%d)""_Rep_reduc_dia.log"    

# Reporte detallado se va generando por cada ejecucion del respaldo y contiene todo el detalle del respaldo
# Lo escribe el programa de respaldo
# El nombre es AA-MM-DD_HHMM_Rep_detall.log

FILE_NAME_REP_DETALL="${SUB_DIR_DETALL_DATE}/""$(date  +%Y-%m-%d_%H%M)""_Rep_detall.log" 

# Inicializar variables varias

# Escribir log de comienzo

# Inicializar archivo de detalle
printf "          Comienzo Detalle: %s  Generado por:  %s %s Version: %s\n" 	"${START_TIME}"  ${0} ${1} ${VERSION}>${FILE_NAME_REP_DETALL}
printf "          File reducido  : %s \n" 	"${FILE_NAME_REP_REDUC_DIA}" 							>>${FILE_NAME_REP_DETALL}

# Inicializar archivo reducido
printf "          Comienzo: %s  Generado por: %s %s Version: %s\n" 	"${START_TIME}"  ${0} ${1} ${VERSION}  >> "${FILE_NAME_REP_REDUC_DIA}"

printf "          Archivo detalle: %s \n" 	"${FILE_NAME_REP_DETALL}" 				 >>${FILE_NAME_REP_REDUC_DIA}

# printf "          File   : %s \n" 	"${SUB_DIR_DETALL_DATE}/${FILE_NAME_REP_DETALL}"

# Ejecutar respaldo
rsync -r ${RUN_TYPE} -t -p -o -g -v ${PROGRESS} --delete -i -s ${ORIGIN_DIR_NAME} ${DEST_DIR_NAME}  >>${FILE_NAME_REP_DETALL} 2>&1
# echo rsync -r ${RUN_TYPE} -t -p -o -g -v --progress --delete -i -s ${ORIGIN_DIR_NAME} ${DEST_DIR_NAME} 


# Escribir log de finalizacion indicando exito o fracaso

END_TIME="$(date  +%Y-%m-%d_%H\:%M\:%S)"


# Verificar status del respaldo
if [ $? -eq 0 ]
then
   printf "          Finalizado OK: %s  \n\n" 	"${END_TIME}"  >> "${FILE_NAME_REP_REDUC_DIA}"
   printf "          Finalizado OK: %s  \n\n" 	"${END_TIME}"  >> "${FILE_NAME_REP_DETALL}"
else
   printf "         Finalizado con error: %s  %s \n\n" 	"${0}" "${END_TIME}"  >> "${FILE_NAME_REP_REDUC_DIA}"
   printf "         Finalizado con error: %s  %s \n\n" 	"${0}" "${END_TIME}"  >> "${FILE_NAME_REP_DETALL}"
fi


