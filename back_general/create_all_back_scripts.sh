#! /bin/bash

# Version 5.0 2022.07.10 Va a crear todos los scripts especificos a partir del los
#                        config files *.cfg

for CONFIG_FILE in *.cfg
do
   bash ./xformer.sh ${CONFIG_FILE}
done   
