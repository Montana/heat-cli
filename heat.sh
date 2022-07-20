#!/bin/bash

while getopts 'lvrhazc' OPTION; do

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
    z)
      BASEURL="http://wttr.in/Santa+Monica+California"
      method="curl -4"
      $method $BASEURL$1
      ;;
    c)
      echo "heat-cli USAGE: $(basename \$0) [-l] [-h] [-v] [-r] [z] [-a somevalue]" >&2
      exit 1
      ;;
  esac
done
shift "$(($OPTIND -1))"
