#!/usr/bin/env sh
if ! test -f "$1"
then
  >&2 echo "ERROR: Can't find file: $1"
  exit 1
fi
mdstart "$1"
