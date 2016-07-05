# Apache PHP

This is an Alpine based image with apache 2.4 and php7.

The following volumes are recommended

- /var/www - For your site content
- /var/log/apache2 - For logs
- /etc/apache2/conf.d/custom - For custom apache config files


## Simple Examples

Run with default index of phpinfo
```
docker run --detach --publish 80:80 --publish 443:443 craigmcmahon/apache-php
```

Run with custom code
```
docker run --detach --volume `pwd`:/var/www --publish 80:80 --publish 443:443 craigmcmahon/apache-php
```
