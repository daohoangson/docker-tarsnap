#!/bin/sh

set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
RESTORE_DIRECTORY_DEFAULT=$( pwd )

if [ -z "$ARCHIVE_NAME" ]; then
	ARCHIVE_NAME="$1"
fi

while [ -z "$ARCHIVE_NAME" ];
do
	"$DIR/list-archives.sh"
	echo "Enter archive name to restore:"
	read ARCHIVE_NAME
done

export DOCKER_CMD_ARGUMENTS="$DOCKER_CMD_ARGUMENTS -v $RESTORE_DIRECTORY_DEFAULT:/restore"

"$DIR/run.sh" -x -f "$ARCHIVE_NAME" -C /restore