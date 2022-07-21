#!/bin/bash

while getopts 'lvrhtazc' OPTION; do

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
      echo "The heat is rising"
      ;;
    t) 
      sh ./lookBusy.sh
      ;;
    a)
      avalue="$OPTARG"
      echo "The pressure method will be in heat-cli v1.2"
      ;;
    z)
      BASEURL="http://wttr.in/Santa+Monica+California"
      method="curl -4"
      $method $BASEURL$1
      ;;
    c)
      echo "heat-cli USAGE: $(basename \$0) [-l] [-h] [-v] [-r] [-z] [-t] [-a somevalue]" >&2
      exit 1
      ;;
  esac
done
shift "$(($OPTIND -1))"
