#!/bin/sh

tarsnapcmd="`which tarsnap`"

echo_stderr () {
  echo "$1" >&2
}

# Sanity

if ! [ -n "$tarsnapcmd" -a -x "$tarsnapcmd" ]
then
  echo_stderr "$0: tarsnap command not found!"
  exit 2
fi

list_all_tarsnap () {
  "${tarsnapcmd}" --list-archives|grep -e '^git\..+\.[0-9]{8}-[0-9]{6}-[0-9]{9}$'|sort
}

list_all_repositories () {
  "${tarsnapcmd}" --list-archives|sed -nr 's/^git\.(.+)\.[0-9]{8}-[0-9]{6}-[0-9]{9}$/\1/p'|sort -u
}

case $1 in
  --tarsnap)
    list_all_tarsnap
    ;;
  *)
    list_all_repositories
    ;;
esac
