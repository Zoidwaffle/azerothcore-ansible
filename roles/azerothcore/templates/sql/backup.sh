#!/bin/bash

set -e

#####################
# Backup databases
#####################

# The destination will default to current location if no variable is given
DESTINATION="$1"

TIMESTAMP="$(date +"%s")"

if [[ -z "${DESTINATION}" ]]; then
  DESTINATION="."
fi

hline(){
  echo "********************************************************************************"
}

backup(){
  echo -n "Backing up database \"$1\": "
  mysqldump "${1}" --no-tablespaces | gzip > "${DESTINATION}/${1}.${TIMESTAMP}.sql.gz" || echo "Failed"
  echo "Done"
}

hline
echo "Initiating backups of databases"
hline

backup "acore_world"
backup "acore_characters"
backup "acore_auth"

hline
echo "Backups complete!"
