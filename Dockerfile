FROM alpine:edge
MAINTAINER Dao Hoang Son <daohoangson@gmail.com>

ENV TARSNAP_VERSION 1.0.36.1

ENV TARSNAP_MAKE_PACKAGES \
	build-base \
	ca-certificates \
	make \
	openssl-dev \
	e2fsprogs-dev \
	wget \
	zlib-dev

ENV TARSNAP_RUN_PACKAGES \
	coreutils \
	openssl

ENV TARSNAP_BUILD_PATH="/src/tarsnap/"

COPY tarsnap-autoconf-$TARSNAP_VERSION.tgz $TARSNAP_BUILD_PATH

RUN apk add --no-cache --update $TARSNAP_MAKE_PACKAGES $TARSNAP_RUN_PACKAGES \
	&& cd $TARSNAP_BUILD_PATH \
	&& tar zxf tarsnap-autoconf-$TARSNAP_VERSION.tgz \
	&& cd tarsnap-autoconf-$TARSNAP_VERSION \
	&& ./configure \
	&& make all install clean \
	&& apk del $TARSNAP_MAKE_PACKAGES \
	&& rm -rf "$TARSNAP_BUILD_PATH" \
	&& (rm "/tmp/"* 2>/dev/null || true) \
	&& (rm -rf /var/cache/apk/* 2>/dev/null || true)

RUN {\
		echo "cachedir $TARSNAP_CACHE_DIR_PATH"; \
		echo "keyfile $TARSNAP_KEY_FILE_PATH"; \
		echo '# Do not archive files which have the nodump flag set'; \
		echo 'nodump'; \
		echo '# Print statistics when creating or deleting archives'; \
		echo 'print-stats'; \
		echo '# Create a checkpoint once per GB of uploaded data'; \
		echo 'checkpoint-bytes 1G'; \
		echo '# See more at http://www.tarsnap.com/man-tarsnap.conf.5.html'; \
	} > /usr/local/etc/tarsnap.conf

VOLUME ["/tarsnap"]

COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["tarsnap"]