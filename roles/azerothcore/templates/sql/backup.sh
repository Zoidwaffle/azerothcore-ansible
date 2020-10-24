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

backup(){
  echo -n "Making a backup of database \"$1\": "
  mysqldump "${1}" | gzip > "${DESTINATION}/${1}.${TIMESTAMP}.sql.gz" || echo "Failed"
  echo "Done"
}

backup "acore_world"
backup "acore_characters"
backup "acore_auth"

echo "Backups complete!"
