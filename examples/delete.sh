#!/bin/sh

set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

if [ -z "$ARCHIVE_NAME" ]; then
	ARCHIVE_NAME="$1"
fi

while [ -z "$ARCHIVE_NAME" ];
do
	"$DIR/list-archives.sh"
	echo "Enter archive name to delete:"
	read ARCHIVE_NAME
done

"$DIR/run.sh" -d -f "$ARCHIVE_NAME"