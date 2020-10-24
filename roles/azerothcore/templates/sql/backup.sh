#!/bin/bash

TIMESTAMP="$(date +"%s")"

#####################
# Backup databases
#####################

backup(){
  echo -n "Making a backup of database \"$1\": "
  mysqldump "${1}" | gzip > "/home/{{ azerothcore_user }}/{{ azerothcore_server_release }}/azerothcore_sql/${1}.${TIMESTAMP}.sql.gz" || echo "Failed"
  echo "Done"
}

backup "{{ azerothcore_db_world }}"
backup "{{ azerothcore_db_characters }}"
backup "{{ azerothcore_db_auth }}"

echo "Backups complete!"
