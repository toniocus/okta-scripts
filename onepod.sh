#!/bin/bash

VERBOSE=0

if [ "$1" = "-v" ]; then
   VERBOSE=1
   shift
fi

if [ $# -ne 2 ]; then
    echo "Usage: $0 [-v] namespace deployment_name"
    echo "  -v  print all data from the pod not just its name"
    exit 1
fi

NAMESPACE="$1"
DEPLOYMENT="$2"

kubectl -n $NAMESPACE get pods -L version --no-headers --selector=project=$DEPLOYMENT |
     ( [ $VERBOSE = "0" ]  && cut -d ' ' -f1 || cat )  

