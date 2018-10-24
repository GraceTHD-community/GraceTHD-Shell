#!/bin/bash

### PARAMETRES A MODIFIER
# base de données
pghostname="127.0.0.1"
pguser="root"
pgpassword="none"
pgport="5432" #default postgres port = 5432
pgdb="e5gracetest"
# suppression des fichiers temporaires (o ou n)
tempdelete="o"
# affichage des commandes sql (o ou n)
echoall="n"

### PARAMETRES A NE PAS MODIFIER
# chemins
glroot=`pwd`/.. #(problèmes dans l'import csv si le répertoire est relatif)
gldbprodschema=${glroot}/sql_postgis
glshpinpath=${glroot}/shpcsv-in
# paramètres shp
pgsrid="2154"
pgcode="cp1252"
# paramètres csv
pgcsvconf="with delimiter ';' csv header encoding 'utf8'"
# utilitaires
if [ ${echoall} = "o" ]; then
  echovalue="--set=ECHO=all";
else
  echovalue="--quiet";
fi
psqlcommandnodb="psql --host=${pghostname} --port=${pgport} --username=${pguser} --set=PGPASSWORD=${pgpassword} --set=ON_ERROR_STOP=1 ${echovalue} --dbname=postgres"
psqlcommand="psql --host=${pghostname} --port=${pgport} --username=${pguser} --set=PGPASSWORD=${pgpassword} --set=ON_ERROR_STOP=1 ${echovalue} --dbname=${pgdb}"
shp2pgsql="shp2pgsql -t 2D -s ${pgsrid} -a -W ${pgcode}"
