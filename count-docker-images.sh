#!/bin/bash
#
# Count docker images
#
#

FILTER='.'
DOCKER_REPOS="/tmp/docker-repos.$$"

if [ ! -z "$1" ]; then
  FILTER=$(printf %q "$1")
fi

echo "Fetching repos from aws....."
aws --region us-west-2 ecr describe-repositories | jq -r '.repositories[] | .repositoryName' | sort > $DOCKER_REPOS

echo "Counting pods..."
for repo in $(cat $DOCKER_REPOS | grep "$FILTER")
do
  LEN=$(aws --region us-west-2 ecr list-images --repository-name $repo --max-items 10000 | jq '.imageIds | length')
  printf "%5d %s\n" $LEN $repo 
done


rm -f $DOCKER_REPOS
