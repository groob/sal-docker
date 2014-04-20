sal-docker
==========

Dockerfile for Sal

#Sal container
the settings should be configured durin the DB step. The sal container uses the linked db container.
##build
In the folder with the Dockerfile, run

```docker build -t sal .```
##run
```docker run -p 80:8080 -d --link sal-postgresql:db sal /sbin/my_init```

#PostgreSQL container

    docker run -d --name="sal-postgresql" \
                 -p 127.0.0.1:5432:5432 \
                 -v /tmp/postgresql:/data \
                 -e USER="saladmin" \
                 -e DB="sal_db" \
                 -e PASS="password" \
                 paintedfox/postgresql

