# Use phusion/passenger-full as base image. To make your builds reproducible, make
# sure you lock down to a specific version, not to `latest`!
# See https://github.com/phusion/passenger-docker/blob/master/Changelog.md for
# a list of version numbers.
FROM phusion/passenger-full:0.9.9

# Set correct environment variables.
ENV HOME /root

# Use baseimage-docker's init process.
CMD ["/sbin/my_init"]

RUN apt-get update && apt-get install -y \
  python-pip \
  python-dev \
  sqlite3 \
  libsqlite3-dev

RUN git clone https://github.com/grahamgilbert/sal.git /home/app/sal

RUN pip install -r /home/app/sal/setup/requirements.txt
RUN cd /home/app/sal/sal && \
    cp example_settings.py settings.py && \
    sed -i 's/#.*Your.*/\("Docker User", "docker@localhost"\)/' settings.py && \
    sed -i 's/TIME_ZONE.*/TIME_ZONE = "America\/New_York"/' settings.py && \
    cd .. && \
    python manage.py syncdb --noinput && \
    python manage.py migrate && \
    python manage.py collectstatic --noinput

ADD passenger_wsgi.py /home/app/sal/
RUN chown -R app:app /home/app/
ADD sal.conf /etc/nginx/sites-enabled/sal.conf
RUN rm -f /etc/nginx/sites-enabled/default.conf
RUN rm -f /etc/service/nginx/down
# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

EXPOSE 8080
