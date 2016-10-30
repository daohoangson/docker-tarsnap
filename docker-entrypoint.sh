#!/bin/sh

set -e

TARSNAP_CACHE_DIR_PATH=${TARSNAP_CACHE_DIR_PATH:-'/tarsnap/cache'}
TARSNAP_KEY_FILE_PATH=${TARSNAP_KEY_FILE_PATH:-'/tarsnap/key'}

TARSNAP_CONF_PATH='/usr/local/etc/tarsnap.conf'

# if command starts with an option, prepend tarsnap
if [ "${1:0:1}" = '-' ]; then
	set -- tarsnap "$@"
fi

if [ "x$1" == 'xtarsnap' ]; then
	{\
		echo "cachedir $TARSNAP_CACHE_DIR_PATH"; \
		echo "keyfile $TARSNAP_KEY_FILE_PATH"; \
		echo '# Do not archive files which have the nodump flag set'; \
		echo 'nodump'; \
		echo '# Print statistics when creating or deleting archives'; \
		echo 'print-stats'; \
		echo '# Create a checkpoint once per GB of uploaded data'; \
		echo 'checkpoint-bytes 1G'; \
		echo '# See more at http://www.tarsnap.com/man-tarsnap.conf.5.html'; \
	} > "$TARSNAP_CONF_PATH" \
	&& echo '####################  Tarsnap Configuration  ####################' \
	&& cat "$TARSNAP_CONF_PATH" \
	&& echo '#################### / Tarsnap Configuration ####################' \
	&& echo ''

	if [ ! -f "$TARSNAP_KEY_FILE_PATH" ]; then
		if [ -z "$TARSNAP_USERNAME" ]; then
			echo "$TARSNAP_KEY_FILE_PATH not found but there is no TARSNAP_USERNAME, exit now"
			exit 1
		fi

		if [ -z "$TARSNAP_PASSWORD" ]; then
			echo "$TARSNAP_KEY_FILE_PATH not found but there is no TARSNAP_PASSWORD, exit now"
			exit 1
		fi

		if [ -z "$TARSNAP_MACHINE_NAME" ]; then
			TARSNAP_MACHINE_NAME=$( hostname )
		fi

		echo "Generating key for user=$TARSNAP_USERNAME, password=xxx, machine=$TARSNAP_MACHINE_NAME..."
		echo "$TARSNAP_PASSWORD" | tarsnap-keygen --keyfile "$TARSNAP_KEY_FILE_PATH" \
			--user "$TARSNAP_USERNAME" \
			--machine "$TARSNAP_MACHINE_NAME"

		echo "Key generated"
		ls -ald "$TARSNAP_KEY_FILE_PATH"
	fi
fi

echo "Executing $@..."
exec "$@"