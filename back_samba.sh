#! /bin/bash
# Version 1.1 2022.06.07
# Version 1.2 2022.06.07 Agregado determinacion de RUN_TYPE del run string
# 							Definir tipo de ejecucion del rsync
# Version 2.0 2022.06.08 Agregada variable VERSION con numero de version
# Version 2.1 2022.06.08 Agregada variables PROGRESS 
# Version 2.4 2022.06.10 Reordenamiento; Creacion de funciones de chequeo, y redireccionamiento
#						 de output de errores a los logs.
# Version 2.6 2022.06.23 Nuevos directorios. Ahora va en serio...
#						 Agregado de --exclude-from=FILE 
#						 Reordenada la inicializacion de los logs. Si el exclude 
# 						 o los dirs origen y destino no estan, no se escribe arch de detalle.

#-----------------------------------------------------------------------
verificar_logs ()
#-----------------------------------------------------------------------
{
#-----------------------------------------------------------------------
# Verificar si los directorios de log estan accesibles
# Estos chequeos serviran en la fase de pruebas manuales
# y no en "produccion" Donde van los mensajes del cron...???
#-----------------------------------------------------------------------
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
#  echo "$0: No existe ${SUB_DIR_DETALL_DATE}"
  mkdir  ${SUB_DIR_DETALL_DATE}
 fi
}
#-----------------------------------------------------------------------

#-----------------------------------------------------------------------
verificar_origen_y_destino ()
#-----------------------------------------------------------------------
{
#-----------------------------------------------------------------------
# ORIGEN 
#-----------------------------------------------------------------------
#                 Origen CON /           (por ahora no....)
# ORIGIN_DIR_NAME="/samba/"
# ORIGIN_DIR_NAME="/media/badubko/badubko-q/Back_F/BAS/DOCS/PS_Adv"

#El siguiente es el directorio origen que debemos asegurarnos que este montado...
MOUNTED_ORIGIN_DIR_NAME="/samba"

# y debe tener la marca que permita controlar eso
ORIGIN_MARK_FILE="${MOUNTED_ORIGIN_DIR_NAME}/.ORIGIN_MARK"

# El siguiente es el directorio que vamos a respladar. Reside dentro del anterior
ORIGIN_DIR_NAME="${MOUNTED_ORIGIN_DIR_NAME}/"
#-----------------------------------------------------------------------
# DESTINO 
#-----------------------------------------------------------------------
#                 Destino SIN /                   v
#El siguiente es el directorio destino que debemos asegurarnos que este montado...
MOUNTED_DEST_DIR_NAME="/samba_0"

# y debe tener la marca que permita controlar eso
DEST_MARK_FILE="${MOUNTED_DEST_DIR_NAME}/.DEST_MARK"

# El siguiente es el directorio al cual vamos a copiar. Reside dentro del anterior
DEST_DIR_NAME="${MOUNTED_DEST_DIR_NAME}"

#-----------------------------------------------------------------------
# Verificar si los directorios origen y destino estan montados
# En ambos deberan estar creados archivos vacios que sirven de marca
# para determinar si estan montados.

if [ ! -f "${ORIGIN_MARK_FILE}" ]
then
  echo -e "$0: No esta montado el directorio origen ${ORIGIN_MARK_FILE}\n" >> "${FILE_NAME_REP_REDUC_DIA}"
  exit
fi

if [ ! -f "${DEST_MARK_FILE}" ]
then
  echo -e "$0: No esta montado el directorio destino ${DEST_MARK_FILE}\n" >> "${FILE_NAME_REP_REDUC_DIA}"
  exit
fi
}
#-----------------------------------------------------------------------
verificar_exclude_file()
#-----------------------------------------------------------------------
{
EXCLUDE_FILE="/opt/back_samba/exclude_patterns_file.txt"
if [ ! -f "${EXCLUDE_FILE}" ]
then
  echo -e "$0: No existe el exclude file: ${EXCLUDE_FILE}\n" >> "${FILE_NAME_REP_REDUC_DIA}"
  exit
fi

}

#-----------------------------------------------------------------------
# script principal
#-----------------------------------------------------------------------

# Inicializar variables varias
VERSION="2.6"

DRY="-n"
REAL=""

PROGRESS_YES="--progress"
PROGRESS_NO=""
PROGRESS=${PROGRESS_NO}
#-----------------------------------------------------------------------

if [ $# -eq 0 ]
then 
 RUN_TYPE="${DRY}"
else
 case "${1,,}" in
 -dry | -d | --dry | -n)
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

verificar_logs 

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


# Escribir logs de comienzo

# Inicializar archivo reducido

printf "          Comienzo: %s  Generado por: %s %s Version: %s\n" 	"${START_TIME}"  ${0} "${RUN_TYPE}" ${VERSION}  >> "${FILE_NAME_REP_REDUC_DIA}"

verificar_origen_y_destino 

verificar_exclude_file

# Aca estamos en condiciones de indicar que habra archivo de detalle

printf "          Archivo detalle: %s\n" 	"${FILE_NAME_REP_DETALL}" 				 >>${FILE_NAME_REP_REDUC_DIA}

# Inicializar archivo de detalle
printf "          Comienzo Detalle: %s \n"  "${START_TIME}"   >${FILE_NAME_REP_DETALL}
printf "          Generado por:  %s %s Version: %s \n" 	 ${0} "${RUN_TYPE}" ${VERSION} >>${FILE_NAME_REP_DETALL}
printf "          File reducido: %s \n" 	"${FILE_NAME_REP_REDUC_DIA}" 							>>${FILE_NAME_REP_DETALL}

# Ejecutar respaldo
printf "          Origen:  %s \n "  ${ORIGIN_DIR_NAME} >>${FILE_NAME_REP_DETALL}
printf "         Destino: %s \n\n" ${DEST_DIR_NAME}   >>${FILE_NAME_REP_DETALL}

#rsync -r ${RUN_TYPE} -t -p -o -g -v ${PROGRESS} --delete --exclude 'timeshift' --exclude '.Trash-1000' --exclude 'lost+found' -i -s ${ORIGIN_DIR_NAME} ${DEST_DIR_NAME}  >>${FILE_NAME_REP_DETALL} 2>&1
rsync -r ${RUN_TYPE} -t -p -o -g -v ${PROGRESS} --delete --exclude-from="${EXCLUDE_FILE}" -i -s ${ORIGIN_DIR_NAME} ${DEST_DIR_NAME}  >>${FILE_NAME_REP_DETALL} 2>&1

# Escribir log de finalizacion indicando exito o fracaso

END_TIME="$(date  +%Y-%m-%d_%H\:%M\:%S)"


# Verificar status del respaldo
if [ $? -eq 0 ]
then
   printf "          Finalizado OK: %s  \n\n" 	"${END_TIME}"  >> "${FILE_NAME_REP_REDUC_DIA}"
   printf "\n          Finalizado OK: %s  \n\n" 	"${END_TIME}"  >> "${FILE_NAME_REP_DETALL}"
else
   printf "         Finalizado con error: %s  %s \n\n" 	"${?}" "${END_TIME}"  >> "${FILE_NAME_REP_REDUC_DIA}"
   printf "         Finalizado con error: %s  %s \n\n" 	"${?}" "${END_TIME}"  >> "${FILE_NAME_REP_DETALL}"
fi


