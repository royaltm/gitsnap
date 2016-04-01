#!/bin/sh

gitsnap_dir="`dirname "$0"`"
listallcmd="${gitsnap_dir}/list-all"
restorecmd="${gitsnap_dir}/restore"

echo_stderr () {
  echo "$1" >&2
}

if ! [ -f "$listallcmd" -a -x "$listallcmd" -a -f "$restorecmd" -a -x "$restorecmd" ]
then
  echo_stderr "$0: gitsnap installation broken!"
  exit 2
fi

"${listallcmd}"| \
while read -r repo_name
do
  echo "Restoring '$repo_name'"
  "${restorecmd}" "$repo_name"
done
