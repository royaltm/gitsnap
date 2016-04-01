#!/bin/sh

tarsnapcmd="`which tarsnap`"
repo_name="`basename "$1" .git`"

echo_stderr () {
  echo "$1" >&2
}

# Sanity

if ! [ -n "$tarsnapcmd" -a -x "$tarsnapcmd" ]
then
  echo_stderr "$0: tarsnap command not found!"
  exit 2
fi

if [ -z "$repo_name" ]
then
  echo_stderr "Usage: $0 repository-name [--all]"
  exit 1
fi

list_all () {
  local name="git.${repo_name}."
  "${tarsnapcmd}" --list-archives|grep -F -e "$name"|grep -E -e '^git\..+\.[0-9]{8}-[0-9]{6}-[0-9]{9}$'|sort
}

list_last () {
  list_all|tail -1
}


case $2 in
  --all)
    list_all
    ;;
  *)
    list_last
    ;;
esac
