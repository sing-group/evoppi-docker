#!/bin/bash

# ---------------------------------#
#       Script functions           #
# ---------------------------------#

display_usage() {
	echo -e "This script deploys an EvoPPI Docker environment. By default, it uses the configuration of the config.latest."
	echo -e "\nUsage:"
	echo -e "\tdeploy.sh"
	echo -e "\tdeploy.sh <config-file>"
} 

show_error_and_exit() {
    tput setaf 1
    echo -e "$1"
    tput sgr0
    exit 1
}

success() {
    tput setaf 2
    echo -e "$1"
    tput sgr0
}

test_command() {
    if ! command -v $1 &> /dev/null
    then
        show_error_and_exit "Error: $1 could not be found, please install it before using this script."
    else
        success "$1 OK"
    fi
}

# ---------------------------------#
#      Input parameters            #
# ---------------------------------#

SCRIPT_DIR=$(dirname "$0")
CONFIG_FILE=${1:-${SCRIPT_DIR}/config.latest}

if [[ $1 == "--help" ]]; then
	display_usage
	exit 0
fi

if [ $# -gt 1 ]
then 
	tput setaf 1
	echo -e "Error. This script requires one or two arguments. \n"
	tput sgr0
	display_usage
	exit 1
fi

tput setaf 2
echo " _____            ____  ____ ___ "
echo "| ____|_   _____ |  _ \|  _ \_ _|"
echo "|  _| \ \ / / _ \| |_) | |_) | |"
echo "| |___ \ V / (_) |  __/|  __/| |"
echo "|_____| \_/ \___/|_|   |_|  |___|"
tput sgr0
echo -e "\nThis script will deploy an EvoPPI Docker environment.\n"

set -o nounset

test_command docker
test_command docker-compose

DOCKER_SERVICE_FILE="/lib/systemd/system/docker.service"
DOCKER_TCP="-H tcp://0.0.0.0:2375"

grep -o ${DOCKER_TCP} ${DOCKER_SERVICE_FILE} &> /dev/null

if [ $? -eq 1 ]; then
    current_exect_start=$(cat ${DOCKER_SERVICE_FILE} | grep 'ExecStart')
    new_exec_start="${current_exect_start} ${DOCKER_TCP}"

    tput setaf 3
    echo -e "\nThe ${DOCKER_SERVICE_FILE} file must be updated to add ${DOCKER_TCP} to the ExecStart configuration option."
    tput sgr0
    echo 'The following command is required to update the Docker configuration: '
    echo 'sudo sed -i "s#ExecStart.*#'${new_exec_start}'#" '${DOCKER_SERVICE_FILE} ' && systemctl daemon-reload && sudo service docker restart'

    read -p "Do you want to run the above command to update the Docker configuration? [Enter y (yes) or n (no)]: " choice
    if [[ "${choice}" == "y" || ${choice} == "yes" ]]; then
        sudo sed -i "s#ExecStart.*#${new_exec_start}#" ${DOCKER_SERVICE_FILE}
        sudo systemctl daemon-reload && sudo service docker restart
        success "docker configuration update OK"
    fi
else
    success "docker configuration OK"
fi

set -o errexit

if [ -f ${CONFIG_FILE} ]; then
    source ${CONFIG_FILE}
    success "Load configuration from ${CONFIG_FILE} OK"
else
    show_error_and_exit "The file ${CONFIG_FILE} does not exist"
fi

EVOPPI_FRONTEND_HOST=${EVOPPI_FRONTEND_HOST:-localhost}
EVOPPI_FRONTEND_HTTP_PORT=${EVOPPI_FRONTEND_HTTP_PORT:-80}

if [ ! -d /tmp/evoppi-docker/ ]; then
    echo "Creating /tmp/evoppi-docker/"
    
    echo "Running sudo chmod u+x ${SCRIPT_DIR}/fix-evoppi-docker-dir.sh"
    sudo chmod u+x ${SCRIPT_DIR}/fix-evoppi-docker-dir.sh

    echo "Running ${SCRIPT_DIR}/fix-evoppi-docker-dir.sh"
    ${SCRIPT_DIR}/fix-evoppi-docker-dir.sh
    success "Run ${SCRIPT_DIR}/fix-evoppi-docker-dir.sh OK"
else
    success "Check /tmp/evoppi-docker OK"
fi

cd ${SCRIPT_DIR}/../

docker-compose build
success "Run docker-compose build OK"

docker-compose up -d
success "Run docker-compose up -d OK"
success "\nAll steps completed successfully!\n"

echo -e "EvoPPI is being deployed. This process may take a while, specially the first time since the database must be created and it takes several hours.\n"
echo -e "Run 'docker-compose logs -f -t' to see the container logs and track the deployment progress.\n"
echo -e "EvoPPI will be available at http://${EVOPPI_FRONTEND_HOST}:${EVOPPI_FRONTEND_HTTP_PORT}\n"
echo -e "Once deployed:"
echo -e "\t- You may log in with admin/admin to be able to use the data management administrator options."
echo -e "\t- Run 'docker-compose stop' to stop the containers without removing them."
echo -e "\t- Run 'docker-compose down' to stop the containers and also removing them as well as any networks that were created."
