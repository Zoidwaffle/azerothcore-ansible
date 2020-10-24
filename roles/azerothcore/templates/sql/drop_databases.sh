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
echo "WARNING: This will drop AzerothCore databases and the AzerothCore user"
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
