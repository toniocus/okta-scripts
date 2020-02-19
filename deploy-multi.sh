export KUBECONFIG=$HOME/.kube/aws-config
unset AWS_PROFILE

ENVIROM=dev2
MODULELIST="ta-comptel-callback,ta-comptel-callout,ta-crm-delivery,ta-guid-task,ta-http-adapter,ta-http-numeracion-movil,ta-http-vminet,ta-huawei-callout,ta-huawei-chown-callout,ta-huawei-chso-co-neil,ta-huawei-disconnect-callout,ta-huawei-fnf-macd,ta-huawei-nc-callout"

if [ $# -eq 0 ]; then
   echo "$0 maven-module [environment (default $ENVIROM)]"
   echo "Need to specify a module"
   exit 1
fi

ENVIROM=$1
VERSION=$2

echo "Deploying to Environment => *$ENVIROM* (Hit [Enter] to Continue)"
read kk

echo "Loging to AWS....."
$(aws ecr get-login --no-include-email)

NEW_VERSION="$(id -un)-$(date '+%y%m%dT%H%M')"

echo
echo "---------------------------------------------------------------------------"
echo "Installing basic modules locally..."
echo "---------------------------------------------------------------------------"
echo 

mvn -N install  &&  mvn -pl ta-common,ta-async-lib install
if [ $? -ne 0 ]; then
   echo
   echo "---------------------------------------------------------------------------"
   echo "Installing basic modules locally FAILED !!!!!!!!!!!!!!"
   echo "---------------------------------------------------------------------------"
   echo
   exit 1
fi

echo
echo "---------------------------------------------------------------------------"
echo "Setting new version to $NEW_VERSION, and deploying..."
echo "---------------------------------------------------------------------------"
echo

for mod in $(echo $MODULELIST | sed 's/,/ /g')
do
        mvn -q -DartifactId=$mod -DnewVersion="$VERSION" versions:set 
done 

mvn -pl $MODULELIST -Dfabric8.namespace=$ENVIROM clean package fabric8:build fabric8:push fabric8:deploy 
    
#mvn -q versions:revert


if [ -f $MODULE/pom.xml.versionsBackup ]; then

    echo
    echo "===================================================================================="
    echo " Process ended with ERRORS"
    echo "------------------------------------------------------------------------------------"
    echo " To restore to previous version, please run this command:"
    echo 
    echo "   mvn versions:revert"
    echo 
    echo "===================================================================================="
    echo

fi


