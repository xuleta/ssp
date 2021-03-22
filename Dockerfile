# Dockerfile for Self Service Password
#                by the LTB Project
# https://ltb-project.org/documentation/self-service-password

FROM php:8.0.3-apache-buster

RUN apt-get update -q && apt-get upgrade -y \
        && apt-get install -y libldap2-dev \
        && rm -rf /var/lib/apt/lists/* \
        && docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu \
        && docker-php-ext-install ldap

RUN curl -O https://ltb-project.org/archives/ltb-project-self-service-password-1.3.tar.gz \
        && tar -zxf ltb-project-self-service-password-1.3.tar.gz \
        && rm -f ltb-project-self-service-password-1.3.tar.gz \
        && mv ltb-project-self-service-password-1.3 /usr/share/self-service-password

COPY ./apache.conf /etc/apache2/sites-available/000-default.conf

RUN mkdir -p /config
RUN ln -sf /config/config.inc.local.php /var/local/ldapssp/conf/config.inc.local.php
RUN ln -sf /config/custom_logo.png /var/local/ldapssp/images/custom_logo.png
RUN ln -sf /config/custom_background.png /var/local/ldapssp/images/custom_background.png
VOLUME /config

WORKDIR /var/local/ldapssp

ENTRYPOINT apache2-foreground