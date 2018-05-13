FROM alpine:3.6

MAINTAINER Shudong Zhu <shudong@eefocus.com>
ENV PHP_VERSION=5.6 

# dependencies required for running "phpize"
		
RUN echo "https://mirrors.aliyun.com/alpine/v3.6/main" > /etc/apk/repositories  \
	&&echo "https://mirrors.aliyun.com/alpine/v3.6/community" >> /etc/apk/repositories  \
    && apk update \
    && apk add --no-cache --virtual .build-deps zlib-dev php5-dev  autoconf dpkg-dev dpkg file g++ gcc libc-dev make pkgconf re2c\ 
	&& apk add --no-cache --virtual .persistent-deps ca-certificates curl tar xz supervisor dcron tzdata \
	&& apk add --no-cache nginx php5 php5-fpm php5-pear php5-bz2 php5-calendar  php5-zlib php5-zip php5-xml php5-sockets php5-soap php5-posix php5-phar php5-pdo_mysql php5-openssl php5-opcache  php5-mcrypt php5-mysqli php5-json php5-iconv php5-gd php5-gettext php5-xmlreader php5-ctype php5-bcmath php5-dom php5-exif php5-curl \
	&& ln -s /usr/bin/php5 /usr/bin/php \
	&& ln -s /usr/bin/phpize5 /usr/bin/phpize \
	&& sed -i "$ s|\-n||g" /usr/bin/pecl \
	&& pecl channel-update pecl.php.net \
	&& echo "" |pecl install redis-3.1.6\
	&& echo "" |pecl install memcache \
	&& echo "extension=memcache.so" > /etc/php5/conf.d/memcache.ini \
	&& echo "extension=redis.so" > /etc/php5/conf.d/redis.ini \
	&& cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && echo "Asia/Shanghai" >  /etc/timezone \
	&& rm -rf /tmp/pear/* \
	&& rm -rf /var/cache/apk/* \
	&& apk del .build-deps \
	#&& rm -rf /etc/nginx/conf.d/* \
	&& mkdir -p /run/nginx \ 
	&& mkdir -p /var/log/supervisor \ 
	&& mkdir /etc/supervisor.d 
    
	
	
COPY start.sh /start.sh
COPY supervisor_nginx_php-fpm.ini /etc/supervisor.d
EXPOSE 80 
EXPOSE 443	 
ENTRYPOINT ["sh","/start.sh"]
