#!/bin/bash

# gracethd_pg_create_db.sh
# Version : 0.01.01
# E5GROUP
# IMPORT DE SHP/CSV GraceTHD-MCD EN BASE PostGIS
# Licence : GNU GPLv3
# Cible Postgis

# 20/09/2018 : stephane.byache at aleno.eu 
# - adaptation pour intégration GraceTHD-Shell
# - https://github.com/GraceTHD-community/GraceTHD-Shell
# - https://redmine.gracethd.org/redmine/issues/468

# 18/03/2016 : E5Group
# Publication du script v0.01 sous GPLv3 : https://redmine.gracethd.org/redmine/issues/200



. ./config.sh

echo Import de la base GraceTHD dans Postgres
echo "Répertoire bin de Postgres :" ${postgresbindir}
echo "Base de données cible :" ${pgdb}
echo "Répertoire des Shapefiles et Csvs :" ${glshpinpath}
echo
read -p "Validez pour continuer..."
echo


###
function loadshp () {
	echo " ------------- loading shp" $1 "-------------"
	multi=""
	if [ $2 = "S" ]; then
		multi="-S"
	fi
	${shp2pgsql} ${multi} ${glshpinpath}/$1.shp $1 > ${glshpinpath}/$1.sql
	${psqlcommand} -f ${glshpinpath}/$1.sql
	if [ ${tempdelete} = "o" ]; then
		rm -f ${glshpinpath}/$1.sql
	fi
	echo "done" $1
	echo
}

###
function loadcsv () {
	echo " ------------- loading csv" $1 "-------------"
	${psqlcommand} -c "copy $1 from '${glshpinpath}/$1.csv' ${pgcsvconf};"
	echo "done" $1
	echo
}

###
loadshp t_adresse S
loadcsv t_organisme
loadcsv t_reference
loadshp t_noeud S
loadcsv t_sitetech
loadcsv t_ltech
loadcsv t_baie
loadcsv t_tiroir
loadcsv t_equipement
loadcsv t_suf
loadcsv t_ptech
loadcsv t_ebp
loadcsv t_cassette
loadshp t_cheminement S
loadcsv t_conduite
loadcsv t_cond_chem
loadcsv t_masque
loadcsv t_cable
loadshp t_cableline S
loadcsv t_cab_cond
loadcsv t_love
loadcsv t_fibre
loadcsv t_position
loadcsv t_ropt
loadcsv t_siteemission
loadshp t_znro M
loadshp t_zsro M
loadshp t_zpbo M
loadshp t_zdep M
loadshp t_coax
loadcsv t_document
loadcsv t_docobj
loadshp t_empreinte M
#patch v2.0.1
loadcsv t_cable_patch201
loadcsv t_zpbo_patch201
loadcsv t_cassette_patch201
loadcsv t_ltech_patch201

echo
echo "the end"
echo

