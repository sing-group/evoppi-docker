# EvoPPI Docker

This project allows deploying EvoPPI using a Docker environment for the database, the backend, and the frontend.

## Requirements

To run this project, first, you will need to install:
- Docker: [https://www.docker.com/community-edition#/download](https://www.docker.com/community-edition#/download)
- Docker Compose: [https://docs.docker.com/compose/install/](https://docs.docker.com/compose/install/)

## Deploy EvoPPI

Download or clone this repository and simply run the following command to create and deploy an EvoPPI Docker environment with the [latest database version](http://evoppi.i3s.up.pt/help):

```
./scripts/deploy.sh
```

## Database versions

The complete information regarding the available database versions and apropriate configuration values is available [here](http://evoppi.i3s.up.pt/help). If you want to deploy a different version, simply put the specified variables into the `scripts/config.custom` file and run:

```
./scripts/deploy.sh ./scripts/config.custom
```

## Advanced configuration

See the [advanced configuration and administration guide](ADVANCED.md) for further details regarding the Docker Compose project options.
