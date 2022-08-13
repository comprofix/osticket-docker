# osTicket Docker

This is a self contained Docker Image for using [osTicket](https://osticket.com/).

# Prerequisites

## Download Config file

Download a copy of the ost-sampleconfig and rename to ost-config.php

```
curl -o ost-config.php https://raw.githubusercontent.com/osTicket/osTicket/1.16.x/include/ost-sampleconfig.php
```

# Usage

It is recommended that you run this container using docker-compose so you can get the database. If you have a separate database you can remove that section or run from the docker-cli.

## docker-compose (recommended)

```
---
version: '3'
services:
  osticket:
    image: comprofix/osticket:latest
    user: root
    ports:
      - 8880:80
      - 8343:443
    volumes:
      - ./ost-config.php:/var/www/html/include/ost-config.php
    restart: unless-stopped
    links:
      - "db:database"
    depends_on:
      - db

  db:
    image: mariadb:latest
    environment:
      MARIADB_ROOT_PASSWORD: osticket
      MARIADB_DATABASE : 'osticket'
      MARIADB_USER : 'osticket'
      MYSQL_PASSWORD: 'osticket'
    volumes:
      - ./mysql:/var/lib/mysql
    restart: unless-stopped
```


## docker cli

You can also run via docker command using example below.

```
docker run -d \
-p 8880:80 \
--mount type=bind,source=/mnt/c/Users/matth/Git/docker-osticket/ost-config.php,target=/var/www/html/include/ost-config.php \
comprofix/osticket:latest
```


## Cron for Email

Cron for fetching email has been configured to fetch every 2 minutes.

After you have setup osTicket, goto Admin -> Emails -> Settings ensure Email fetching is enabled, but fetch on auto-cron is not.



