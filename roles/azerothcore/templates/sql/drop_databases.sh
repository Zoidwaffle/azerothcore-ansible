#!/bin/bash

set -e

if [ "$EUID" -ne 0 ]
  then echo "Please run as 'sudo $(basename $0)'"
  exit
fi

hline(){
  echo "********************************************************************************"
}

hline
echo "WARNING: This will drop the following databases:"
echo "-  {{ azerothcore_db_characters }}"
echo "-  {{ azerothcore_db_auth }}"
echo "-  {{ azerothcore_db_world }}"
echo "and the user:"
echo "-  {{ azerothcore_db_user }}"
hline
echo "Take a backup if you want to keep your data!"
hline
read -p "Continue? (y/n) [n] : " yn; [[ -n ${yn} ]] || yn="n"
  case $yn in
    [Yy] )
      hline
      echo "Dropping databases"
      mysql -e "DROP DATABASE {{ azerothcore_db_world }};"
      mysql -e "DROP DATABASE {{ azerothcore_db_auth }};"
      mysql -e "DROP DATABASE {{ azerothcore_db_characters }};"
      mysql -e "DROP USER IF EXISTS '{{ azerothcore_db_user|quote }}'@'{{ azerothcore_db_server|quote }}';"
      ;;
    * )
      echo "Exiting" && exit 1
      ;;
  esac
