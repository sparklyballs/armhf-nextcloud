FROM sparklyballs/base-vanilla-armhf
MAINTAINER sparklyballs

# set nextcloud version
ENV NEXTCLOUD_VER="9.0.50"

# install build-dependencies
RUN \
 apk add --no-cache --virtual=build-dependencies \
	autoconf \
	automake \
	g++ \
	gcc \
	git \
	make \
	php5-dev \
	re2c \
	samba-dev && \

# fetch php smbclient source
 git clone git://github.com/eduardok/libsmbclient-php.git /tmp/smbclient && \

# compile smbclient
 cd /tmp/smbclient && \
	phpize && \
	./configure && \
		make && \
		make install && \

# uninstall build-dependencies
 apk del --purge \
	build-dependencies && \

# cleanup
 rm -rfv /tmp/*

# install runtime packages
RUN \
 apk add --no-cache \
	curl \
	ffmpeg \
	libxml2 \
	php5-apache2 \
	php5-apcu \
	php5-bz2 \
	php5-ctype \
	php5-curl \
	php5-dom \
	php5-exif \
	php5-ftp \
	php5-gd \
	php5-gmp \
	php5-iconv \
	php5-imap \
	php5-intl \
	php5-json \
	php5-ldap \
	php5-mcrypt \
	php5-openssl \
	php5-pcntl \
	php5-pdo_mysql \
	php5-pdo_pgsql \
	php5-pdo_sqlite \
	php5-posix \
	php5-xml \
	php5-zip \
	php5-zlib \
	samba \
	tar \
	unzip && \

# configure smbclient php extension
echo "extension="smbclient.so"" >> /etc/php5/php.ini

# add local files
COPY root/ /

# ports and volumes
VOLUME /config /data
EXPOSE 443
