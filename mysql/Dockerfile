FROM ubuntu:14.04.4
MAINTAINER Andrea Manzi <manzolo@libero.it>

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update
RUN apt-get -y install mysql-server mysql-client

ARG DATABASE_PASSWORD=shroot12
ENV DATABASE_PASSWORD $DATABASE_PASSWORD

RUN sed -i -e"s/^bind-address\s*=\s*127.0.0.1/bind-address = 0.0.0.0/" /etc/mysql/my.cnf

ADD start-db.sh /opt/start-db.sh
RUN chmod +x /opt/start-db.sh
EXPOSE 3306
CMD ["/bin/bash", "/opt/start-db.sh"]

#Debug
#docker build --build-arg DATABASE_PASSWORD=manzolo -t manzolo/mysql:linked .
#docker run -d -v /var/lib/mysql-linked-container:/var/lib/mysql --name linkedmysql -p 33060:3306 manzolo/mysql:linked
#docker exec -i -t linkedmysql /bin/bash
#docker run -it manzolo/mysql:linked /bin/bash

#docker stop $(docker ps -a -q) && docker rm $(docker ps -a -q)
