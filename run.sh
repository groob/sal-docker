#!/bin/sh

cd /home/app/sal && \
   sed -i "s/db_host/$DB_PORT_5432_TCP_ADDR/" sal/settings.py && \
   python manage.py syncdb --noinput && \
   python manage.py migrate && \
   python manage.py collectstatic --noinput
