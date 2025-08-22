#!/bin/bash
# This script copies the scaffolding files to the specified destination directory.

DESTINATION=$1

if [ ! -d "$DESTINATION" ]; then
  echo "Destination directory does not exist or is not a directory."
  echo "Usage: init.sh <destination directory>"
  exit 1
fi

cp -r .opencode/ "$DESTINATION"
cp AGENTS.md "$DESTINATION"
cp FABRIC.md "$DESTINATION"
