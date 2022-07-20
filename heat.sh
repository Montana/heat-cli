#!/bin/bash

while getopts 'lvrha' OPTION; do

  case "$OPTION" in
    l)
      echo "heat-cli is installed"
      ;;
    v)
    echo "heat-cli version 1.0 by Montana Mendy"
      ;;
    r)
    echo "Turning the heat up at Facebook"
      ;;
    h)
      echo "you have supplied the -h option"
      ;;
    a)
      avalue="$OPTARG"
      echo "The value provided is $OPTARG"
      ;;
    ?)
      echo "script usage: $(basename \$0) [-l] [-h] [-v] [-r] [-a somevalue]" >&2
      exit 1
      ;;
  esac
done
shift "$(($OPTIND -1))"
