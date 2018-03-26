# Evoppi Docker

This project allows the deployment of an EvoPPI Environment in docker.

## Requirements

* Docker: [https://www.docker.com/community-edition#/download](https://www.docker.com/community-edition#/download)
* Docker Compose: [https://docs.docker.com/compose/install/](https://docs.docker.com/compose/install/)

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