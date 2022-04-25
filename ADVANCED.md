# EvoPPI Docker - Advanced Configuration and Administration Guide

## Docker configuration

EvoPPI uses the Docker's remote REST API, that should be enabled and configured to listen in the TCP address `0.0.0.0:2375`. For Debian systems, depending on whether your system uses `systemd` or not, you can follow these tutorials:

  * Without `systemd` (e.g. Ubuntu <= 14.10): https://dor.ky/enabling-docker-remote-api-on-ubuntu/
  * With `systemd` (e.g. Ubuntu >= 15.04): https://www.ivankrizsan.se/2016/05/18/enabling-docker-remote-api-on-ubuntu-16-04/

For instance, the default `ExecStart` entry in Ubuntu >= 15.04 systems in the `/lib/systemd/system/docker.service` file may look like:
```
ExecStart=/usr/bin/dockerd -H fd:// --containerd=/run/containerd/containerd.sock
```

In this case, you just need to add `-H tcp://0.0.0.0:2375` at the end of that line to make it look like the following:
```
ExecStart=/usr/bin/dockerd -H fd:// --containerd=/run/containerd/containerd.sock -H tcp://0.0.0.0:2375
```

And restart Docker running `systemctl daemon-reload && sudo service docker restart`.

## EvoPPI configuration

### Build parameters

The `docker-compose.yml` uses default values for most of the customizable parameters to allow a quick EvoPPI deployment. Nevertheless, you may need to select a different EvoPPI or database version, or set custom URLs. Almost all of this configuration parameters are set using environment variables, defined in either the command line (using `export VARIABLE=value`) or an `.env` properties file.

The parameters that must be defined before building the Docker images are:
- `EVOPPI_DATABASE_VERSION`: the database version.
- `EVOPPI_DATABASE_ADMIN_PASSWORD`: the password of the *admin* user set when the database is created (default is `admin`).
- `EVOPPI_DATABASE_RESEARCHER_PASSWORD`: the password of the *researcher* user set when the database is created (default is `researcher`).
- `EVOPPI_BACKEND_HOST`: the URL where the EvoPPI backend of this deployment will be available. Default is `localhost:8080`.
- `EVOPPI_BACKEND_VERSION`: the EvoPPI backend version.
- `EVOPPI_BACKEND_EAR_BUILD`: the EvoPPI backend EAR version (the same as `EVOPPI_BACKEND_VERSION` for stable releases).
- `EVOPPI_FRONTEND_HOST`: the URL where the EvoPPI frontend of this deployment will be available. Default is `localhost`.
- `EVOPPI_FRONTEND_VERSION`: the EvoPPI frontend version.

### E-mail

In case you need a working EvoPPI e-mail configuration, you need to edit the `wildfly10/docker-standalone.xml` file before building the Docker images. Specifically, you need to change some parameters in the `urn:jboss:domain:naming:2.0` subsystem and edit the `urn:jboss:domain:mail:2.0` subsystem.

For instance, the `urn:jboss:domain:mail:2.0` subsystem must be edited to add the username, password, and whether SSL is used or not:

```xml
        <subsystem xmlns="urn:jboss:domain:mail:2.0">
            <mail-session name="default" jndi-name="java:jboss/mail/Default">
                <smtp-server outbound-socket-binding-ref="mail-smtp" username="user@host" password="password" ssl="true"/>
            </mail-session>
            <mail-session name="evoppi-mail" jndi-name="java:/evoppi/mail">
                <smtp-server outbound-socket-binding-ref="mail-smtp" username="user@host" password="password" ssl="true"/>
            </mail-session>
        </subsystem>
```

And then, the `mail-smtp` settings must be updated in the `urn:jboss:domain:naming:2.0` subsystem.

### Temporary directory

The backend image mounts the `/tmp/evoppi-docker` directory to create temporary results. To ensure that the container can write into this directory, you can change the user's permissions with `chmod a+w /tmp/evoppi-docker`. If you want to change the temporary folder, please, read the *Deployment* section.

To guarantee that this directory is properly configured in every reboot of the server where EvoPPI is deployed, the `scripts/fix-evoppi-docker-dir.sh` script can be added to the crontab with `crontab -e`:
```
@reboot /path/to/evoppi-docker/scripts/fix-evoppi-docker-dir.sh
```

### Deployment

Finally, other configuration parameters (the ports ant the temporary directory) can be changed when starting the images (unlike versions, that must be set before building the images). Like building parameters, these are set using environment variables, defined in either the command line (using `export VARIABLE=value`) or an `.env` properties file.  These paremeters are:

- `TEMP_DATA_DIRECTORY`: temporary directory used by the EvoPPI image (default value: `/tmp/evoppi-docker`).
- `BACKEND_AJP_PORT`: the AJP port (default value: `8009`).
- `BACKEND_HTTP_PORT`: the HTTP port of the backend (default value: `8080`).
- `BACKEND_HTTP_MANAGEMENT_PORT`: the HTTP  management port of the backend (default value: `9990`).
- `FRONTEND_HTTP_PORT`: the HTTP port of the frontend (default value: `80`).

## Building images

Use the following commands in order to build all the images:

```docker
export COMPOSE_PROJECT_NAME=evoppidocker

export EVOPPI_DATABASE_VERSION=1.0.0

export EVOPPI_BACKEND_HOST=localhost:8080
export EVOPPI_BACKEND_VERSION=1.2.0
export EVOPPI_BACKEND_EAR_BUILD=1.2.0

export EVOPPI_FRONTEND_HOST=localhost
export EVOPPI_FRONTEND_VERSION=1.2.0

docker-compose build
```

The `COMPOSE_PROJECT_NAME` variable is set to use always the same project name regardless of the project location (this way, images will be always named with `evoppi-docker_*`). 

As explained before, all the environment variables can be defined in an `.env` properties file:

```
COMPOSE_PROJECT_NAME=evoppidocker
EVOPPI_DATABASE_VERSION=1.0.0
EVOPPI_BACKEND_HOST=localhost:8080
EVOPPI_BACKEND_VERSION=1.2.0
EVOPPI_BACKEND_EAR_BUILD=1.2.0
EVOPPI_FRONTEND_HOST=localhost
EVOPPI_FRONTEND_VERSION=1.2.0
```

## Running containers

To run all the images use the following command (the `-d` parameter tells the daemon to run the images in detached mode):

```docker
docker-compose up -d
```

The first time it will take some time as it neets to build the database. Run `docker-compose logs -f -t` to see the container logs.

### Database

The database is stored in a volume called `evoppidocker_evoppi-database-data`. The database is only initialized using the files under `/docker-entrypoint-initdb.d/` the first time the containers is started ant the volume is created. If the volume already exists, those files are not used. To force the container to re-apply them, the volume must be removed using `docker volume rm evoppidocker_evoppi-database-data`.

In case you need to copy volumes for some reasons, take a look at the `docker_clone_volume.sh` script of [this project](https://github.com/gdiepen/docker-convenience-scripts).

## Stopping containers

Run `docker-compose stop` to stop the containers without removing them. 

Run `docker-compose down` to stop the containers and also removing them as well as any networks that were created.
