#!/bin/bash

if [ $# -ne 2 ]; then
    echo "Usage: $0 namespace deployment_name"
    exit 1
fi

NAMESPACE="$1"
DEPLOYMENT="$2"

kubectl -n $NAMESPACE get pods -L version --no-headers --selector=project=$DEPLOYMENT 

