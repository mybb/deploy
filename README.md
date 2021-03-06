# MyBB Development Stack (Docker Compose)

Development stack (PHP interpreter, web server, database server) for the [MyBB forum software](https://mybb.com). Not for production use.

## Quick Start
1. Install the [Docker Engine](https://docs.docker.com/engine/install/) and [Docker Compose](https://docs.docker.com/compose/install/).
2. Clone/download this repository on your computer, placing it next to the MyBB source code directory (which can be a cloned [`mybb/mybb` repository](https://github.com/mybb/mybb)):

   ```
   .
   ├── mybb/
   └── deploy/
   ```

3. In the `deploy/` directory, run:

   ```sh
   docker compose up
   ```

   Once the services are running, MyBB should be available at `http://localhost:8080`.

## Database Systems
The following database engines are available for MyBB installation:
- **PostgreSQL** (enabled by default):
  - Database Host: `postgresql`
  - Database Name: `mybb`
  - Database User: `mybb`
  - Database Password: `mybb`
- **MySQL**:
  - Database Host: `mysql`
  - Database Name: `mybb`
  - Database User: `mybb`
  - Database Password: `mybb`
- **SQLite** (if supported by the PHP configuration)


By default, only the PostgreSQL service is started. To start the MySQL service, include the `db.mysql` profile in the `.env` file:
```dotenv
COMPOSE_PROFILES=php.prebuilt,db.mysql
```
and restart.

## Switching PHP Versions
By default, PHP 8.0 is used. To switch the PHP version, change it in the `.env` file (see [available X.Y versions](https://dockerfile.readthedocs.io/en/latest/content/DockerImages/dockerfiles/php-dev.html#docker-image-tags)):
```dotenv
PHP_VERSION=7.4
```

and restart the container with `docker compose up -d`.

### Using Custom Images
To use PHP versions not available in the pre-built images, but included in an [official PHP base image](https://hub.docker.com/_/php?tab=tags&page=1&ordering=last_updated), use the  `php.custom` profile:
```dotenv
PHP_VERSION=8.1.0RC2
COMPOSE_PROFILES=php.custom,db.postgresql
```
and build it using
```sh
docker compose build
```
and restart.

## Environment Variables
The following variables can be set in the `.env` file:

Name | Default | Description
---|---|---
`SOURCE_PATH` | `../mybb` | Path to served files
`PHP_VERSION` | `8.0` | PHP version to use. Depends on available base images
`XDEBUG` | `1` | Whether to install [Xdebug](https://xdebug.org/) when building a custom PHP image
`NGINX_PUBLISHED_PORT` | `8080` | The port accessible from the host machine 
`POSTGRESQL_PUBLISHED_PORT` | `6432` | The port accessible from the host machine
`MYSQL_PUBLISHED_PORT` | `4306` | The port accessible from the host machine
`COMPOSE_PROFILES` | `php.prebuilt,db.postgresql` | PHP image (`prebuilt` or `custom`) and database service (`postgresql` or `mysql`) to use
