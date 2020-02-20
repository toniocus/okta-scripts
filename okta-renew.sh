#!/bin/bash

if [ -n "$1" ]; then
    profileName=$1
else

    profileName=$AWS_PROFILE

    if [ -z "$AWS_PROFILE" ]; then
        profileName=${1:-"default"}
    fi
fi

echo "Renewing for profile $profileName...."

source $TA_HOME/bin/okta-cli.sh
source jdk11+
okta-aws $profileName sts get-caller-identity

