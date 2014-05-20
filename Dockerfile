FROM debian:stable
MAINTAINER e.a.agafonov@gmail.com

RUN apt-get update
RUN apt-get upgrade -y

RUN apt-get install -y openssh-server apache2 supervisor

RUN mkdir -p /var/run/sshd
RUN mkdir -p /var/log/supervisor

ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf

ADD id_rsa.pub /root/.ssh/authorized_keys
RUN chown root:root /root/.ssh/authorized_keys

# install postgresql
RUN apt-get -y -q install postgresql-9.1 postgresql-client-9.1 postgresql-contrib-9.1
USER postgres

RUN /etc/init.d/postgresql start && \
    psql --command "CREATE USER docker WITH SUPERUSER PASSWORD 'docker';" && \
    createdb --encoding=utf-8 --template=template0 --owner=docker docker

# Adjust PostgreSQL configuration so that remote connections to the
# database are possible. 
RUN echo "host all  all    0.0.0.0/0  md5" >> /etc/postgresql/9.1/main/pg_hba.conf

# And add listen_addresses to /etc/postgresql/9.1/main/postgresql.conf
RUN echo "listen_addresses='*'" >> /etc/postgresql/9.1/main/postgresql.conf


EXPOSE 5432

USER root

EXPOSE 22 80
CMD ["/usr/bin/supervisord"]




