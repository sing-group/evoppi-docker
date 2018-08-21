#!/bin/bash

QUERY="$(mysql -e 'SELECT * FROM user' -u evoppi -pevoppipass -h evoppi-database evoppi)"
RESULT=$?
echo "command result ${RESULT}"
echo "query result ${QUERY}"

while [ ${RESULT} -ne 0 ] || [ "${QUERY}" -eq "" ];
do
  echo "Waiting for database ($SECONDS s)";
  sleep 5;
  QUERY="$(mysql -e 'SELECT * FROM user' -u evoppi -pevoppipass -h evoppi-database evoppi)"
done;

echo "Starting WildFly";

/opt/jboss/wildfly/bin/standalone.sh -b "0.0.0.0" -bmanagement "0.0.0.0" -Dhost.address="172.20.0.1" -Dtemp.directory="$TEMP_DATA_DIRECTORY";
