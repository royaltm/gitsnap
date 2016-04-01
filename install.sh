#!/bin/sh

source_dir="`dirname "$0"`"
destination_dir="$1"

gitcmd="`which git`"
tarsnapcmd="`which tarsnap`"

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

install_scripts () {
  local options="$*"
  install $options "$source_dir"/scripts/post-receive.sh "$destination_dir"/            || exit 3
  install $options "$source_dir"/scripts/create.sh       "$destination_dir"/create      || exit 3
  install $options "$source_dir"/scripts/restore.sh      "$destination_dir"/restore     || exit 3
  install $options "$source_dir"/scripts/restore-all.sh  "$destination_dir"/restore-all || exit 3
  install $options "$source_dir"/scripts/list.sh         "$destination_dir"/list        || exit 3
  install $options "$source_dir"/scripts/list-all.sh     "$destination_dir"/list-all    || exit 3
}

if [ "`id -u`" != "0" ]
then
  install_scripts -m 700
else
  LC_ALL=C ls -ld "$destination_dir" | {
    read -r perm links user group stuff || exit 3

    install_scripts -o $user -g $group -m 700
  }
fi
