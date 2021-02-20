#!/bin/bash
# Usage: ./clone-github.sh --single <getdefinedinrepos> --all <getallreposforuser>
# Usage: ./clone-github.sh <no params === get everything>
single=${single:-UNSET_PARAM}
all=${all:-UNSET_PARAM}
while [ $# -gt 0 ]; do
   if [[ $1 == *"--"* ]]; then
        param="${1/--/}"
        declare $param="$2"
        # echo $1 $2 // Optional to see the parameter:value result
   fi
  shift
done

go get github.com/tomnomnom/getgithubrepos

# Clone targeted repos
declare -a REPOS=("brycereynolds" "swisskyrepo")
# Clone all repos
declare -a GET_ALL_REPOS=("payloadbox")

if [ "$single" != "UNSET_PARAM" ] || [ "$all" != "UNSET_PARAM" ]; then
  if [ "$single" != "UNSET_PARAM" ]; then
    CLONE_DIR="$HOME/src/github.com/$single"
    mkdir -p $CLONE_DIR
    cd $CLONE_DIR
    cat "$HOME/src/github.com/brycereynolds/dotfiles/repos/$single.txt" | xargs -n1 git clone
  fi

  if [ "$all" != "UNSET_PARAM" ]; then
    CLONE_DIR="$HOME/src/github.com/$all"
    mkdir -p $CLONE_DIR
    cd $CLONE_DIR
    getgithubrepos $all | xargs -n1 git clone 
  fi
else
  for val in "${REPOS[@]}"; do
    echo $val
    CLONE_DIR="$HOME/src/github.com/$val"
    mkdir -p $CLONE_DIR
    cd $CLONE_DIR
    cat "$HOME/src/github.com/brycereynolds/dotfiles/repos/$val.txt" | xargs -n1 git clone
  done

  go get github.com/tomnomnom/getgithubrepos
  for val in "${GET_ALL_REPOS[@]}"; do
    CLONE_DIR="$HOME/src/github.com/$val"
    mkdir -p $CLONE_DIR
    cd $CLONE_DIR
    getgithubrepos $val | xargs -n1 git clone 
  done
fi
