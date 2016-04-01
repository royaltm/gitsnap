#!/bin/sh

gitsnap_dir="`dirname "$0"`"
repo_name="`basename "$1" .git`"
repo_dir="${gitsnap_dir}/${repo_name}.git"
post_receive_path="${gitsnap_dir}/post-receive.sh"
gitcmd="`which git`"

echo_stderr () {
  echo "$1" >&2
}

if ! [ -n "$gitcmd" -a -x "$gitcmd" ]
then
  echo_stderr "$0: git command not found!"
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

"${gitcmd}" init --bare --shared "$repo_dir" || exit 4
ln -s "../../post-receive.sh" "$repo_dir"/hooks/post-receive || exit 5
