#!/bin/bash

# gracethd_pg_create_db.sh
# Version : 0.01.01
# CREATION D'UNE BASE GRACETHD-MCD
# Licence : GNU GPLv3
# Cible : Postgis

# 20/09/2018 : stephane.byache at aleno.eu 
# - adaptation pour intégration GraceTHD-Shell
# - https://github.com/GraceTHD-community/GraceTHD-Shell
# - https://redmine.gracethd.org/redmine/issues/468

# 18/03/2016 : E5Group
# Publication du script v0.01 sous GPLv3 : https://redmine.gracethd.org/redmine/issues/200

. ./config.sh

echo Création de la base GraceTHD dans Postgres
echo "Répertoire bin de Postgres :" ${postgresbindir}
echo "Base de données cible :" ${pgdb}
echo ATTENTION LA BASE ${pgdb} SERA DETRUITE
echo
read -p "Validez pour continuer..."
echo

###
echo Suppression de la base de données ${pgdb}
${psqlcommandnodb} <<AAA
drop database if exists ${pgdb}
AAA
echo

echo Creation de la base de données ${pgdb}
${psqlcommandnodb} <<AAA
create database ${pgdb}
AAA
#\c ${pgdb}
echo

###
echo Ajout des options SIG
${psqlcommand} <<AAA
create extension postgis;
AAA
echo

###
echo Création de la structure de la base de données
echo Création des listes
${psqlcommand} < ${gldbprodschema}/gracethd_10_lists.sql
echo Insert valeurs dans les listes
${psqlcommand} < ${gldbprodschema}/gracethd_20_insert.sql
echo Création des tables
${psqlcommand} < ${gldbprodschema}/gracethd_30_tables.sql
echo Ajout des champs geometriques
${psqlcommand} < ${gldbprodschema}/gracethd_40_postgis.sql
echo Ajout des index
${psqlcommand} < ${gldbprodschema}/gracethd_50_index.sql
echo Ajout des vues élementaires
${psqlcommand} < ${gldbprodschema}/gracethd_61_vues_elem.sql
echo Ajout des vues élementaires (vues matérialisées)
${psqlcommand} < ${gldbprodschema}/gracethd_61_vues_elem_vmat.sql
echo Ajout des triggers
${psqlcommand} < ${gldbprodschema}/gracethd_80_triggers.sql
echo Ajout des spécificités
${psqlcommand} < ${gldbprodschema}/gracethd_90_labo.sql
echo Ajout des patchs
${psqlcommand} < ${gldbprodschema}/gracethd_91_patchs.sql
echo Application des rôles
${psqlcommand} < ${gldbprodschema}/gracethd_99_grant.sql
echo




