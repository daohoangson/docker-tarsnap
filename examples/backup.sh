#!/bin/sh

set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
ARCHIVE_NAME_DEFAULT="$( uname -n )-$( date +%Y-%m-%d_%H-%M-%S )"
BACKUP_DIRECTORY_DEFAULT=$( pwd )

if [ -z "$ARCHIVE_NAME" ]; then
	echo "Enter archive name (leave blank to use $ARCHIVE_NAME_DEFAULT):"
	read ARCHIVE_NAME

	if [ -z "$ARCHIVE_NAME" ]; then
		ARCHIVE_NAME="$ARCHIVE_NAME_DEFAULT"
	fi
fi

if [ -z "$BACKUP_DIRECTORY" ]; then
	echo "Enter directory to backup (leave blank to use current directory, $BACKUP_DIRECTORY_DEFAULT):"
	read BACKUP_DIRECTORY

	if [ -z "$BACKUP_DIRECTORY" ]; then
		BACKUP_DIRECTORY="$BACKUP_DIRECTORY_DEFAULT"
	fi
fi

export DOCKER_CMD_ARGUMENTS="$DOCKER_CMD_ARGUMENTS -v $BACKUP_DIRECTORY:/$ARCHIVE_NAME"

"$DIR/run.sh" -c -f "$ARCHIVE_NAME" "/$ARCHIVE_NAME"