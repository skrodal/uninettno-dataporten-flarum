FROM php:5.6-fpm

MAINTAINER Simon Skrødal <simon.skrodal@uninett.no>
MAINTAINER Andreas Åkre Solberg <andreas@solweb.no>

# ------------------
# PHP & EXTENSIONS
# ------------------

RUN apt-get update \
    && apt-get install -y libpng12-dev libjpeg-dev pwgen python-setuptools curl git unzip wget git nginx nano \
    && rm -rf /var/lib/apt/lists/* \
    && docker-php-ext-configure gd --with-png-dir=/usr --with-jpeg-dir=/usr \
    && docker-php-ext-install gd mysqli opcache zip mbstring pdo_mysql

# ------------------
# HOME/WORKING DIR
# ------------------

RUN mkdir /app
WORKDIR /app

# ------------------
# SUPERVISOR
# ------------------

RUN /usr/bin/easy_install supervisor
RUN /usr/bin/easy_install supervisor-stdout

# ------------------
# SERVICES
# ------------------

COPY etc/start.sh /start.sh
RUN chmod 755 /start.sh

# ------------------
# COMPOSER
# ------------------

RUN bash -c "wget http://getcomposer.org/composer.phar && mv composer.phar /usr/local/bin/composer"
RUN chmod a+x /usr/local/bin/composer

# ------------------
# FLARUM
# ------------------

# RUN /usr/local/bin/composer create-project flarum/flarum . --stability=beta
RUN /usr/local/bin/composer create-project flarum/flarum . v0.1.0-beta.5 --stability=beta
RUN chmod -R a+rX .

# Replace a troublesome Flarum install-file (specific to v0.1.0-beta.5) with one that works
COPY etc/flarum/Server.php vendor/flarum/core/src/Console

# Add an 'ENV-version' of Flarum's config file (in case we do not want a new Flarum install)
COPY etc/flarum/config.php config.php_

# Copy over fonts (in case we do not use Flarum's installer, which does the same)
RUN cp -a vendor/flarum/core/assets/fonts/ assets/fonts/

# Dataporten extension
RUN composer require uninett/flarum-ext-auth-dataporten

# Norwegian translation extension
RUN composer require pladask/flarum-ext-norwegian-bokmal

# Set permissions
RUN chmod 775 /app
RUN chmod -R 775 /app/storage
RUN chmod -R 775 /app/assets
RUN chown -R root:www-data /app


# ------------------
# NGINX
# ------------------

RUN echo "daemon off;" >> /etc/nginx/nginx.conf
COPY etc/supervisord.conf /etc
COPY etc/nginx-site.conf /etc/nginx/sites-available/default

EXPOSE 80

CMD ["/bin/bash", "/start.sh"]