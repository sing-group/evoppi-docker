#!/bin/bash

QUERY="$(mysql -e 'SELECT * FROM user' -u evoppi -pevoppipass -h evoppi-database evoppi)"
RESULT=$?

while [ ${RESULT} -ne 0 ] || [ -z "${QUERY}" ];
do
  echo "Waiting for database ($SECONDS s)";
  sleep 30;
  QUERY="$(mysql -e 'SELECT * FROM user' -u evoppi -pevoppipass -h evoppi-database evoppi)"
  RESULT=$?
done;

echo "Starting WildFly";

/opt/jboss/wildfly/bin/standalone.sh -b "0.0.0.0" -bmanagement "0.0.0.0" -Dhost.address="172.30.0.1" -Dtemp.directory="$TEMP_DATA_DIRECTORY";
