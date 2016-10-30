#!/bin/sh

set -e

PWD=$( pwd )
HOSTNAME=$( hostname )
DATA_DIR_PATH="$PWD/data"
TARSNAP_KEY_FILE_PATH="$DATA_DIR_PATH/key"

if [ ! -f "$TARSNAP_KEY_FILE_PATH" ]; then
	while [ -z "$TARSNAP_USERNAME" ];
	do
		echo "Enter tarsnap.com username:"
		read TARSNAP_USERNAME
	done

	while [ -z "$TARSNAP_PASSWORD" ];
	do
		echo "Enter tarsnap.com password:"
		read -s TARSNAP_PASSWORD
	done

	if [ -z "$TARSNAP_MACHINE_NAME" ]; then
		echo "Enter machine name (leave blank to use $HOSTNAME):"
		read TARSNAP_MACHINE_NAME

		if [ -z "$TARSNAP_MACHINE_NAME" ]; then
			TARSNAP_MACHINE_NAME="$HOSTNAME"
		fi
	fi
fi


DOCKER_CMD=''
DOCKER_CMD=$( echo "$DOCKER_CMD"; echo "docker run --rm \\" )
DOCKER_CMD=$( echo "$DOCKER_CMD"; echo "	-v $DATA_DIR_PATH:/tarsnap \\" )

if [ ! -z "DOCKER_CMD_ARGUMENTS" ]; then
	DOCKER_CMD=$( echo "$DOCKER_CMD"; echo "	$DOCKER_CMD_ARGUMENTS \\" )
fi

if [ ! -z "$TARSNAP_USERNAME" ]; then
	DOCKER_CMD=$( echo "$DOCKER_CMD"; echo "	-e TARSNAP_USERNAME=$TARSNAP_USERNAME \\" )
fi
if [ ! -z "$TARSNAP_PASSWORD" ]; then
	DOCKER_CMD=$( echo "$DOCKER_CMD"; echo "	-e TARSNAP_PASSWORD=$TARSNAP_PASSWORD \\" )
fi
if [ ! -z "$TARSNAP_MACHINE_NAME" ]; then
	DOCKER_CMD=$( echo "$DOCKER_CMD"; echo "	-e TARSNAP_MACHINE_NAME=$TARSNAP_MACHINE_NAME \\" )
fi

DOCKER_CMD=$( echo "$DOCKER_CMD"; echo "	xfrocks/docker-tarsnap "$@"" )

echo "run.sh executing $DOCKER_CMD..."
eval "$DOCKER_CMD" 