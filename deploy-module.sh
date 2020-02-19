#export KUBECONFIG=$HOME/.kube/okta-config
#unset AWS_PROFILE

source /u/ta/bin/okta-cli.sh

ENVIROM=sit01

if [ -z SKIP_TESTS ]; then
    SKIP_TESTS=false
fi

RENEW=1
if [ -n "$NORENEW" ]; then
    RENEW=0
fi

if [ $# -eq 0 ]; then
   echo "$0 maven-module [environment (default $ENVIROM)]"
   echo "Need to specify a module"
   exit 1
fi


if [ ! -d $1 ]; then
    echo "Module $1 does not exist"
    echo "Be sure you are in the maven integration-project root directory"
    exit 1
fi


MODULE=$(echo $1 | sed 's:/::')

if [ -n "$2" ]; then
  ENVIROM=$2
fi


echo "Deploying to Environment => *$ENVIROM* (Hit [Enter] to Continue)"
read kk

#$(aws ecr get-login --no-include-email)

if [ $RENEW -eq 1 ]
then

    # Renewing okta token......
    okta-renew.sh tools-vlocity
    #okta-aws $AWS_PROFILE sts get-caller-identity
    if [ $? -ne 0 ]; then
        echo "Not able to execute renew"
        exit 1
    fi

    # Renewing okta token......
    okta-renew.sh default
    #okta-aws $AWS_PROFILE sts get-caller-identity
    if [ $? -ne 0 ]; then
        echo "Not able to execute renew"
        exit 1
    fi
    echo "Loging to AWS....."
    $(aws ecr get-login --region us-west-2 --registry-ids 625811157828 --no-include-email --profile default | sed 's/https:\/\///')
    if [ $? -ne 0 ]; then
        echo "Not able to execute aws get-login"
        exit 1
    fi

    #$(okta-aws default ecr get-login --no-include-email | sed 's/https:\/\///')
else
   echo "Not renewing Okta credentials..."
fi


#NEW_VERSION="jc-$(date '+%y%m%dT%H%M')"
NEW_VERSION="$(id -un)-$(date '+%y%m%dT%H%M')"

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

echo
echo "---------------------------------------------------------------------------"
echo "Setting new version to $NEW_VERSION, and pushing..."
echo "---------------------------------------------------------------------------"
echo

mvn -q -DartifactId=$MODULE -DnewVersion="$NEW_VERSION" versions:set \
    && mvn -pl $MODULE -Dfabric8.verbose=true -Dmaven.test.skip=$SKIP_TESTS -Dfabric8.namespace=$ENVIROM clean package fabric8:build fabric8:push  
    
BUILD_STATUS=$?

echo "Reverting version change....."
mvn -q versions:revert


if [ $BUILD_STATUS -ne 0 ]; then

    echo
    echo "---------------------------------------------------------------------------"
    echo "Build FAILED no artifacts will be deployed"
    echo "---------------------------------------------------------------------------"

else

    KUBE_YML="$MODULE/target/classes/META-INF/fabric8/kubernetes.yml"
    if [ ! -f $KUBE_YML ]; then
        echo "$KUBE_YML configuration not found, module cannot be deployed"
    else
        echo
        echo "---------------------------------------------------------------------------"
        echo " Deploying to k8s...."
        echo "    kubectl apply "--namespace=$ENVIROM" -f $KUBE_YML"
        echo "---------------------------------------------------------------------------"
        echo
        kubectl apply "--namespace=$ENVIROM" -f $KUBE_YML
    fi
fi



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


