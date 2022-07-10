#! /bin/bash

# Version 5.0 2022.07.10 Va a deployar todos los scripts especificos a partir del los
#                        config files *.cfg

for CONFIG_FILE in *.cfg
do
   bash ./deploy_back_general.sh ${CONFIG_FILE}
done   
