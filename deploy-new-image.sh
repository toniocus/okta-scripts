#!/bin/bash


kaws='kubectl  --context admin-cluster --namespace dev-ta '

PROJECT=ta-guid-task
DOCKER_IMAGE=625811157828.dkr.ecr.us-west-2.amazonaws.com/ta/ta-guid-task
DOCKER_VERSION=ta-89

echo "Going to deploy to AWS project $PROJECT"
echo 'hit [ENTER] to continue'
read kk

echo "calling kubectl run........"
$kaws run $PROJECT --image=$DOCKER_IMAGE:$DOCKER_VERSION --port 80

echo "calling kubectl expose........"
$kaws expose deployment $PROJECT --type=NodePort --port 80 --target-port 80

