#!/bin/sh

source_dir="`dirname "$0"`"
destination_dir="$1"

gitcmd="`which git`"
tarsnapcmd="`which tarnsap`"

# Sanity

if ! [ -n "$gitcmd" -a -x "$gitcmd" ]
then
  echo "$0: install git first!"
  exit 2
fi

if ! [ -n "$tarsnapcmd" -a -x "$tarsnapcmd" ]
then
  echo "$0: install tarsnap first!"
  exit 2
fi

# Usage

if [ -z "$destination_dir" ]
then
  echo "Usage: $0 path/to/gitsnap"
  exit 1
fi

# Access

if ! [ -d "$destination_dir" -a -x "$destination_dir" -a -w "$destination_dir" ]
then
  echo "$0: no access to directory: '${destination_dir}'"
  exit 1
fi

install -m 700 "$source_dir"/scripts/post-receive.sh "$destination_dir"/ && \
install -m 700 "$source_dir"/scripts/create.sh       "$destination_dir"/create && \
install -m 700 "$source_dir"/scripts/restore.sh      "$destination_dir"/restore && \
install -m 700 "$source_dir"/scripts/restore-all.sh  "$destination_dir"/restore-all && \
install -m 700 "$source_dir"/scripts/list.sh         "$destination_dir"/list && \
install -m 700 "$source_dir"/scripts/list-all.sh     "$destination_dir"/list-all || exit 3
