# Evoppi Docker

This project allows the deployment of an EvoPPI Environment in docker.

## Requirements

To run this project, first, you will need to install:
* Docker: [https://www.docker.com/community-edition#/download](https://www.docker.com/community-edition#/download)
* Docker Compose: [https://docs.docker.com/compose/install/](https://docs.docker.com/compose/install/)

In addition, Docker's remote REST API should be enabled and configured to listen in the TCP address `172.20.0.1:2375`. For Debian systems, depending on whether your system uses `systemd` or not, you can follow these tutorials:

  * Without `systemd` (e.g. Ubuntu <= 14.10): https://dor.ky/enabling-docker-remote-api-on-ubuntu/
  * With `systemd` (e.g. Ubuntu >= 15.04): https://www.ivankrizsan.se/2016/05/18/enabling-docker-remote-api-on-ubuntu-16-04/

## Building images

In order to build all the images use the following command:

```docker
docker-compose build
```

## Running containers

In order to run all the images use the following command:

```docker
docker-compose up
```

The first time it will take some time as it neets to build the database.

## Changing configuration [Experimental]

Some configuration parameters can be changed when starting the image, to do so, you just have to add the parameters to change as enviroment paramenters. For example, you can change the temporal data directory as follows:

```
export TEMP_DATA_DIRECTORY=/home/evoppi/temp
docker-compose up
```

Alternatively, a `.env` properties file can be created with the variable configuration. For example:
```
TEMP_DATA_DIRECTORY=/home/evoppi/temp
BACKEND_HTTP_PORT=8080
```

### Parameters
Change temporal data directory (must be writeable by the docker user):

  * **Directory**: `TEMP_DATA_DIRECTORY` (default value: `/tmp/evoppi-docker`)

Change backend ports:

  * **HTTP port**: `BACKEND_HTTP_PORT` (default value: `8080`)
  * **HTTP management port**: `BACKEND_HTTP_MANAGEMENT_PORT` (default value: `9990`)

Change frontend port:

  * **HTTP port**: `FRONTEND_HTTP_PORT` (default value: `80`)
