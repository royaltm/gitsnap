#!/bin/sh

gitsnap_dir="`dirname "$0"`"
repo_name="`basename "$1" .git`"
repo_time="$2"
repo_dir="${gitsnap_dir}/${repo_name}.git"
post_receive_path="${gitsnap_dir}/post-receive.sh"
gitcmd="`which git`"
tarsnapcmd="`which tarsnap`"

echo_stderr () {
  echo "$1" >&2
}

if ! [ -n "$gitcmd" -a -x "$gitcmd" ]
then
  echo_stderr "$0: git command not found!"
  exit 2
fi

if ! [ -n "$tarsnapcmd" -a -x "$tarsnapcmd" ]
then
  echo_stderr "$0: tarsnap command not found!"
  exit 2
fi

if ! [ -f "$post_receive_path" -a -x "$post_receive_path" -a -x "$gitsnap_dir" -a -w "$gitsnap_dir" -a -r "$gitsnap_dir" ]
then
  echo_stderr "$0: gitsnap installation broken!"
  exit 2
fi

if [ -z "$repo_name" ]
then
  echo_stderr "Usage: $0 new-repository-name"
  exit 1
fi

if [ -d "$repo_dir" ]
then
  echo_stderr "$0: repository '${repo_dir}' already exists!"
  exit 3
fi

list_all_reversed () {
  local name="git.${repository_name}."
  "${tarsnapcmd}" --list-archives|grep -F -e "$name"|grep -E -e '^git\..+\.[0-9]{8}-[0-9]{6}-[0-9]{9}$'|sort -r
}

list_last () {
  list_all_reversed|head -1
}

list_last_before_time () {
  list_all_reversed|awk -F . -v time="$repo_time" '{ if ($3 <= time) { print; exit; } }'
}

if [ -n "$repo_time" ]
then
  if ! (echo "$repo_time" | grep -Eq -e '^[0-9]{4}([0-9]{2}([0-9]{2}(-[0-9]{2}([0-9]{2}([0-9]{2}(-[0-9]+)?)?)?)?)?)?$')
  then
    echo_stderr "Usage: $0 repository-name [yyyy[mm[dd-[HH[MM[SS-[NNNNNNNNN]]]]]]]"
    exit 1
  fi
  archive_name="`list_last_before_time`"
else
  archive_name="`list_last`"
fi

if [ -z "$archive_name" ]
then
  echo_stderr "$0: nothing to restore"
  exit
fi

echo "Restoring '${archive_name}' to '${repo_dir}'"
"${tarsnapcmd}" -x -f "$archive_name" -p -o -C "$gitsnap_dir" || exit 4
ln -fs "../../post-receive.sh" "$repo_dir"/hooks/post-receive || exit 5
LC_ALL=C ls -l "$gitsnap_dir" | {
  read -r perm links user group stuff || exit 5
  chown -R -- "$user:$group" "$repo_dir" || exit 6
}
