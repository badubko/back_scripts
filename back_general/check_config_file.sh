#! /bin/bash

check_config_file()
{
if [ ${N_ARGS} -eq 0 ]
then 
 echo -e "No se proporciono el nombre del config file..."
 echo -e "Usage: $0 <config_file_name.cfg> \n"
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

}
