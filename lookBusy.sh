#!/bin/bash

function keyboard_interrupt() {
  trap SIGINT
  if [[ -f linuxSource ]]; then
    rm -rf linux-0.01.tar.gz linux linuxSource
  fi
  exit
}

function lookBusy () {
  while [[ true ]]; do
    while read l; do
      s=$RANDOM
      let "s %= 9"
      sleep 0.$s
      echo $l
    done < $1
  done
}

function main () {
  if [[ $# -eq 0 ]]; then
    wget https://www.kernel.org/pub/linux/kernel/Historic/linux-0.01.tar.gz > /dev/null 2>&1
    tar xvfz linux-0.01.tar.gz > /dev/null 2>&1
    cat linux/*/*.c > linuxSource
    lookBusy linuxSource
  else
    lookBusy $1
  fi
}

trap keyboard_interrupt INT
main $1
trap SIGINT
