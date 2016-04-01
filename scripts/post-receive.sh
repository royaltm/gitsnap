#!/bin/sh
#
# Create link to this file in repo-dir.git/hooks
#
# cd ~/.repo/git/$my_repository/hooks
# ln -s ../../post-receive.sh ./post-receive
#
repo_dir="`pwd`"
repo_name="`basename "$repo_dir" .git`"

tarsnapcmd=tarsnap
tarsnapkey="${repo_dir}/../../.gitsnap.key"
tarsnapcache="${repo_dir}/../../.gitsnap-cache"

gitsnap () {
  suffix=`date +%Y%m%d-%H%M%S-%N`
  tarsnapfile="git.${repo_name}.${suffix}"
  echo "---"
  echo "$tarsnapfile"
  "${tarsnapcmd}" -c --keyfile "$tarsnapkey" --cachedir "$tarsnapcache" --print-stats \
    -f "${tarsnapfile}" \
    -C "${repo_dir}/.." \
    "${repo_name}.git"
}

gitsnap
