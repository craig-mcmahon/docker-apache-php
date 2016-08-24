FROM alpine:3.4
MAINTAINER Craig McMahon

ENV PHP_VERSION="7.0.10-r1" \
    APACHE_VERSION="2.4.23-r1" \
    OPENSSL_VERSION="1.0.2h-r1" \
    COMPOSER_VERSION="1.2.0" \
    COMPOSER_CHECKSUM="21e6bc3672a3d7df683d1ff85a5f89a857a24e5cf563cc714e9331d9b76bdfc232494599c5188604dce18c6edd0ba8d015ca738537d99e985c58d94b9b466f43  composer.phar" \
    PHPUNIT_VERSION="5.5.2" \
    PHPUNIT_CHECKSUM="6ca91fe656b1f92b18f20437abe09bc21e85d003c78a8ec4c2186fe7fcafe28651d4bbcdd4e96799e01740ac8e7af2a7dffe8e5ce7d9d4e4cce6ee7989144467  phpunit-5.5.2.phar"


# Install modules and updates
RUN apk update \
    && apk --no-cache add \
        openssl=="${OPENSSL_VERSION}" \
        apache2=="${APACHE_VERSION}" \
        apache2-ssl \
    # Install PHP from testing
    && apk --no-cache --repository http://dl-4.alpinelinux.org/alpine/edge/testing add \
        php7=="${PHP_VERSION}" \
        php7-bcmath \
        php7-bz2 \
        php7-calendar \
        php7-common \
        php7-ctype \
        php7-curl \
        php7-dom \
        php7-json \
        php7-mbstring \
        php7-mcrypt \
        php7-memcached \
        php7-mysqlnd \
        php7-opcache \
        php7-openssl \
        php7-pdo \
        php7-pdo_mysql \
        php7-phar \
        php7-session \
        php7-sockets \
        php7-xml \
        php7-xmlreader \
        php7-apache2 \
    && ln -s /usr/bin/php7 /usr/bin/php \
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
