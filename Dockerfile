FROM php:7.4-apache as processwire
RUN apt-get update \
    && apt-get -y install locales locales-all \
    && locale-gen en_US.UTF-8
RUN a2enmod rewrite
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8
ADD https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/
COPY php-local.ini "$PHP_INI_DIR/conf.d/php-local.ini"
COPY php-timezone.ini "$PHP_INI_DIR/conf.d/php-timezone.ini"
RUN chmod +x /usr/local/bin/install-php-extensions \
    && mv "$PHP_INI_DIR/php.ini-development" "$PHP_INI_DIR/php.ini" \
    && install-php-extensions gd pdo_mysql mysqli zip
RUN mkdir -p /var/www/html \
    && cd /var/www/html \
    && curl -sSL https://github.com/processwire/processwire/archive/refs/tags/3.0.200.tar.gz -o - \
    | tar -xz --strip-components=1 \
    && mv site-blank site \
    && chown -R www-data site \
    && chown www-data install.php \
    && chown www-data .gitignore
