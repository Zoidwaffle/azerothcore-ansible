#!/bin/bash

TIMESTAMP="$(date +"%s")"

#####################
# Backup databases
#####################

backup(){
  echo -n "Making a backup of database \"$1\": "
  mysqldump "${1}" | gzip > "/home/{{ azerothcore_user }}/{{ azerothcore_server_release }}/azerothcore_db/${1}.${TIMESTAMP}.sql.gz" || echo "Failed"
  echo "Done"
}

backup "{{ azerothcore_db_world }}"
backup "{{ azerothcore_db_characters }}"
backup "{{ azerothcore_db_auth }}"

echo "Backups complete!"
#!/bin/bash

#####################
# Backup databases
#####################

# The destination will default to current location if no variable is given
DESTINATION="$1"

TIMESTAMP="$(date +"%s")"

if [[ -z "${DESTINATION}" ]]; then
  DESTINATION="."
fi

backup(){
  echo -n "Making a backup of database \"$1\": "
  mysqldump "${1}" | gzip > "${DESTINATION}/${1}.${TIMESTAMP}.sql.gz" || echo "Failed"
  echo "Done"
}

backup "acore_world"
backup "acore_characters"
backup "acore_auth"

echo "Backups complete!"
