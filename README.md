# PgHero Solo

** forked from ankane/pghero_solo which is forked from bmorton/pghero_solo **

This repository is a containerized, standalone instance of the excellent [PgHero engine](https://github.com/ankane/pghero).  It allows you to pass a `DATABASE_URL` environment variable to run PgHero within Docker against your database. `SECRET_KEY_BASE` environment variable must be passed for production environment currently set in the Dockerfile. The Dockerfile must be altered to run in "development" if this environment variable is not desired. 

Usage:
```
docker run -d -it -e DATABASE_URL=postgres://user:pass@host:5432/db -e SECRET_KEY_BASE=secrettokenhere -p 8080:8080 jamesrudd-dev/pghero:tag
```
