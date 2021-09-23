ARG PHP_VERSION=8.0

FROM php:${PHP_VERSION}-fpm-alpine

ARG XDEBUG=false

RUN set -ex; \
	\
	apk add --no-cache --virtual .build-deps \
		$PHPIZE_DEPS \
		libmemcached-dev \
		freetype-dev \
		libjpeg-turbo-dev \
		libpng-dev \
		libwebp-dev \
		postgresql-dev \
	;

RUN set -ex; \
	docker-php-ext-configure gd --with-freetype --with-jpeg --with-webp; \
	docker-php-ext-install -j "$(nproc)" \
		gd \
		mysqli \
		opcache \
		pgsql \
		pdo_pgsql \
		pdo_mysql \
	; \
	pecl channel-update pecl.php.net; \
	pecl install memcached redis; \
	docker-php-ext-enable memcached redis; \
	\
	runDeps="$( \
		scanelf --needed --nobanner --format '%n#p' --recursive /usr/local/lib/php/extensions \
			| tr ',' '\n' \
			| sort -u \
			| awk 'system("[ -e /usr/local/lib/" $1 " ]") == 0 { next } { print "so:" $1 }' \
	)"; \
	apk add --virtual .mybb-phpexts-rundeps $runDeps; \
	apk del .build-deps

RUN { \
	echo 'file_uploads=On'; \
	echo 'upload_max_filesize=10M'; \
	echo 'post_max_size=10M'; \
	echo 'max_execution_time=20'; \
	echo 'memory_limit=256M'; \
	} > /usr/local/etc/php/conf.d/mybb-recommended.ini

RUN if [ "$XDEBUG" = 1 ] ; then \
		apk add --no-cache pcre-dev ${PHPIZE_DEPS}; \
		pecl install xdebug; \
		docker-php-ext-enable xdebug; \
		apk del pcre-dev ${PHPIZE_DEPS}; \
	fi ;

RUN if [ "$XDEBUG" = 1 ] ; then \
		mkdir /var/log/xdebug; \
		chown www-data:www-data /var/log/xdebug; \
	fi ;

WORKDIR /var/www/html

CMD ["php-fpm"]
