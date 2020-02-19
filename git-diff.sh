#!/bin/bash

base_hash=`git log --format=%H -1 $1`

# list all commits between start and end of a version
git log --format="%H" $1^..$2 | while read commit_hash; do
    # check if this commit is reeaaaaally part of the release note
    merge_base=`git merge-base $1 ${commit_hash}`

    if [ "${merge_base}" = "${base_hash}" ]; then 
        # profit
        git l -n 1 $commit_hash
    fi
done
