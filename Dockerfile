FROM alpine:edge
MAINTAINER Sebastian Knoth <sk@bytepark.de>

## Add basic stuff
RUN echo "ipv6" >> /etc/modules
RUN apk add --update --no-cache bash

# Add NGINX-Webserver with NAXSI
RUN apk upgrade -U && \
    apk --update --repository=http://dl-4.alpinelinux.org/alpine/edge/testing add \
    mariadb \
    pwgen

# Small fixes
RUN rm -fr /var/cache/apk/*

#change bind address to 0.0.0.0
RUN sed -i -r 's/bind-address.*$/bind-address = 0.0.0.0/' /etc/mysql/my.cnf

ADD create_mariadb_admin_user.sh /create_mariadb_admin_user.sh
ADD run.sh /run.sh
RUN chmod 775 /*.sh

# Define mountable directories
VOLUME ["/etc/mysql", "/var/lib/mysql"]

#Added to avoid in container connection to the database with mysql client error message "TERM environment variable not set"
ENV TERM dumb

# Expose Ports
EXPOSE 3306

CMD ["/run.sh"]