# DataLink tests on PG15

> The following information is not an official guide, nor will we provide any kind of support in case something is not working. 
> We would highly appreciate any idea or comment, which could help making things work in an easier way. Thank you!  

> DO NOT DO any of the below on a productive system.

## Introduction
DataLink, even in the current version 21.1000.4, only supports Postgres 9.6 as Database.

Postgres 9.6 is EoL and EoSupport. Currently the installer is no longer available from the Postgres Website.

The Idea behing the tests, is to have DataLink running on a newer Postgres 15. (Same version that is supported by MagicINFO 21.1050.0)

### The issue
Since Postgres 14, the default encryption for Postgres is `SCRAM-SHA-256`, and no longer `md5`

I tried modifying Postgres configs, but also if postgres is manually set to accept `md5` passwords, connection fails as the jdbc driver used in DataLink is somehow not able to handle the connection to Postgres 15.

Manually changing Postgres 15 configuration could also have negative imacts on MagicINFO or other applications running on the same Database. 

### The idea
Im going to add a PG Proxy (PGCat) in between the client (DataLink) and the Database (Postgres 15). PGCat should handle md5 connections from the "outdated" jdbc driver, then forward the requests to the DB. 

> Probably, updating the JDBC driver (and flyway for updates) on DataLink side could solve the issue, but I was not successful on that path.

## Prerequisites
- Running Postgres 15 on a server
- needed access to the Postgres config files 
- Docker installed on the server (I will have PGCat running as a container on the server)
- 

## Preparation

Prepare the Proxy (PGCat) as docker compose :

```
- Root folder
  |- docker-compose.yml
  |- pgcat.toml
```

`docker-compose.yml`

```yml
version: "3.8"

services:
    pgcat:
        image: pgedge/pgcat:latest
        container_name: pgcat
        restart: always
        ports:
          - "6432:6432"
        volumes:
          - ./pgcat.toml:/etc/pgcat/pgcat.toml

```

This will later start a container running `pgcat` ans listening to port `6432` on the host.

Then prepare a pgcat config file (Save the file on the same folder as the `docker-compose.yml` is ):

`pgcat.toml`

```toml
[general]
host = "0.0.0.0"
port = 6432
log_level = "debug"
admin_username = ""
admin_password = "" 

[pool]
mode = "transaction"
default_pool_size = 10
min_pool_size = 5
max_pool_size = 50

# [users]
# # The client (your app) connects using this user and password (MD5 hashed)
# datalink.password = "md5a6adcb9c3d0eaa4e02b6b66a422bb0fa"
# datalink.pool_size = 10

[pools.postgres]

[pools.postgres.users.0]
pool_size = 10
username = "postgres"
password = "samsung01" # should match your postgres user password

[pools.postgres.shards.0]
database = "postgres"
servers = [
    ["host.docker.internal", 5432, "primary"],
]

[pools.datalink]

[pools.datalink.users.0]
pool_size = 10
username = "postgres"
password = "samsung01" # should match your postgres user password

[pools.datalink.shards.0]
database = "postgres"
servers = [
    ["host.docker.internal", 5432, "primary"],
]
```

Start the PGProxy
```
docker compose up -d
```

you can use any postgresql client to check if PG Cat is working, by conneting the client to 

``` 
localhost:6432/postgres
``` 
using the credentials `postgres` with the password you set (`samsung01` in this example)

> note the port **6432** which is not PostgreSQL, but PGCat

## Step-by-step


tbc

run `init.bat`, then 

add `?prepareThreshold=0` to the `datalink.default.url`
new:
```yaml
###############################################################################
# DEFAULT JDBC INFO (DEFAULT : H2)
###############################################################################
datalink.default.datasource=jdbc/DataSource
datalink.default.driver=org.postgresql.Driver
datalink.default.url=jdbc:postgresql://localhost:5432/datalink?prepareThreshold=0
datalink.default.username=postgres
datalink.default.password=samsung01
# Initial DB Connection pool size
datalink.default.initial_size=10
# Max DB Connection pool size
datalink.default.max_active=70
# Max Wating Connection Timeout
datalink.default.max_wait=5000
# Max DB Connection pool idle size
datalink.default.max_idle=200

# ConnectionPool type=DS: Java datasource, H2: H2 datasource
datalink.default.connectionpool=postgres

```
then run `dbupdate.bat`