#!/bin/bash

SCRIPT_DIR=$(dirname "$0")

count=$(docker ps -a | grep evoppi | wc -l)
if [ ! ${count} -eq 3 ]; then
	${SCRIPT_DIR}/deploy.sh
fi

xdg-open http:localhost
