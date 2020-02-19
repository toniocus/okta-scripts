#!/bin/bash

if [ $# -ne 2 ]; then
    echo "Usage: $0 namespace deployment_name"
    exit 1
fi

NAMESPACE="$1"
DEPLOYMENT="$2"
DESTINATION_PORT=9088

echo "Fetching pod name..."
POD=$(onepod.sh $NAMESPACE $DEPLOYMENT | awk '{print $1}')

echo "Forwarding pod's $POD 80 port to $DESTINATION_PORT.." 
kubectl -n $NAMESPACE port-forward $POD $DESTINATION_PORT:80
