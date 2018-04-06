#!/bin/bash

while [ "$(mysql -e 'SELECT * FROM user' -u evoppi -pevoppipass -h evoppi-database evoppi)" == "" ];
do
  echo "Waiting for database ($SECONDS s)";
  sleep 1;
done;

echo "Starting WildFly";

/opt/jboss/wildfly/bin/standalone.sh -b "0.0.0.0" -bmanagement "0.0.0.0" -Dhost.address="172.20.0.1" -Dtemp.directory="$TEMP_DATA_DIRECTORY";
