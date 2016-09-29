FROM alpine:3.4
MAINTAINER Craig McMahon

ENV PHP_VERSION="7.0.11-r0" \
    APACHE_VERSION="2.4.23-r1" \
    OPENSSL_VERSION="1.0.2j-r0" \
    COMPOSER_VERSION="1.2.1" \
    COMPOSER_CHECKSUM="1fee0f09cf73fe177754648a5c8a2f97b9cf8f7943f2b5c1325ace677573f2b623300197af5863e588737a49d43ca075ce4af07e0752e139797815450bd6f9a0  composer.phar" \
    PHPUNIT_VERSION="5.5.5" \
    PHPUNIT_CHECKSUM="719271d620cb8395cf68e637aa3b7f9e24f7223328c3cf85a87304d598e17caebf59e05a458e4ff9ddf437313fbb8ec729c05859c4eeb6e28769faa5ba06f3c4  phpunit-5.5.5.phar"

# Install modules and updates
RUN apk update \
    && apk --no-cache add \
        openssl=="${OPENSSL_VERSION}" \
        apache2=="${APACHE_VERSION}" \
        apache2-ssl \
        git \
    && apk --no-cache --repository http://dl-4.alpinelinux.org/alpine/edge/main add \
        apache2-http2 \
    # Install PHP from community
    && apk --no-cache --repository http://dl-4.alpinelinux.org/alpine/edge/community add \
        php7=="${PHP_VERSION}" \
        php7-bcmath \
        php7-bz2 \
        php7-calendar \
        php7-common \
        php7-ctype \
        php7-curl \
        php7-dev \
        php7-dom \
        php7-json \
        php7-mbstring \
        php7-mcrypt \
        php7-mysqlnd \
        php7-opcache \
        php7-openssl \
        php7-pdo \
        php7-pdo_mysql \
        php7-pdo_sqlite \
        php7-phar \
        php7-session \
        php7-sockets \
        php7-xml \
        php7-xmlreader \
        php7-apache2 \
    && ln -s /usr/bin/php7 /usr/bin/php \
    && apk --no-cache --repository http://dl-4.alpinelinux.org/alpine/edge/testing add \
        php7-memcached \
    && rm /var/cache/apk/* \

    # Run required config / setup for apache
    # Ensure apache can create pid file
    && mkdir /run/apache2 \
    # Fix group
    && sed -i -e 's/Group apache/Group www-data/g' /etc/apache2/httpd.conf \
    # Fix ssl module
    && sed -i -e 's/LoadModule ssl_module lib\/apache2\/mod_ssl.so/LoadModule ssl_module modules\/mod_ssl.so/g' /etc/apache2/conf.d/ssl.conf \
    && sed -i -e 's/LoadModule socache_shmcb_module lib\/apache2\/mod_socache_shmcb.so/LoadModule socache_shmcb_module modules\/mod_socache_shmcb.so/g' /etc/apache2/conf.d/ssl.conf \
    # Enable modules
    && sed -i -e 's/#LoadModule rewrite_module modules\/mod_rewrite.so/LoadModule rewrite_module modules\/mod_rewrite.so/g' /etc/apache2/httpd.conf \
    # Change document root
    && sed -i -e 's/\/var\/www\/localhost\/htdocs/\/var\/www/g' /etc/apache2/httpd.conf \
    && sed -i -e 's/\/var\/www\/localhost\/htdocs/\/var\/www/g' /etc/apache2/conf.d/ssl.conf \
    # Allow for custom apache configs
    && mkdir /etc/apache2/conf.d/custom \
    && echo '' >> /etc/apache2/httpd.conf \
    && echo 'IncludeOptional /etc/apache2/conf.d/custom/*.conf' >> /etc/apache2/httpd.conf \
    # Fix modules
    && sed -i -e 's/ServerRoot \/var\/www/ServerRoot \/etc\/apache2/g' /etc/apache2/httpd.conf \
    && mv /var/www/modules /etc/apache2/modules \
    && mv /var/www/run /etc/apache2/run \
    && mv /var/www/logs /etc/apache2/logs \
    # Empty /var/www and add an index.php to show phpinfo()
    && rm -rf /var/www/* \
    && echo '<?php phpinfo(); ?>' >  /var/www/index.php \
    # Install composer
    && wget https://getcomposer.org/download/${COMPOSER_VERSION}/composer.phar \
    && echo "${COMPOSER_CHECKSUM}" > composerchecksum.txt \
    && sha512sum -c composerchecksum.txt \
    && rm composerchecksum.txt \
    && mv composer.phar /usr/bin/composer \
    && chmod +x /usr/bin/composer \
    # Install phpunit
    && wget https://phar.phpunit.de/phpunit-${PHPUNIT_VERSION}.phar \
    && echo "${PHPUNIT_CHECKSUM}" > phpunitchecksum.txt \
    && sha512sum -c phpunitchecksum.txt \
    && rm phpunitchecksum.txt \
    && mv phpunit-${PHPUNIT_VERSION}.phar /usr/bin/phpunit \
    && chmod +x /usr/bin/phpunit


WORKDIR /var/www

# Export http and https
EXPOSE 80 443

# Run apache in foreground
CMD ["/usr/sbin/httpd", "-D", "FOREGROUND"]
