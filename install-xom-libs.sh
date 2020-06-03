#!/bin/bash
#
#  runs mvn install for all the common artifacts needed in project.
#
#

if [ -z SKIP_TESTS ]; then
    SKIP_TESTS=false
fi

echo
echo "---------------------------------------------------------------------------"
echo "Installing basic modules locally..."
echo "---------------------------------------------------------------------------"
echo 

LIBS="ta-test,ta-common,ta-async-lib,repro-commons"

if [ -d ta-callout-lib ] && grep '<module.*ta-callout-lib.*module>' pom.xml >/dev/null
then
    LIBS=$LIBS",ta-callout-lib"
fi

mvn -N install  &&  mvn -pl $LIBS clean install

if [ $? -ne 0 ]; then
   echo
   echo "---------------------------------------------------------------------------"
   echo "Installing basic modules locally FAILED !!!!!!!!!!!!!!"
   echo "---------------------------------------------------------------------------"
   echo
   exit 1
fi

