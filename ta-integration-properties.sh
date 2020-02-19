

if [ $# -ne 2 ]; then
  echo Usage: $0 k8s-namespace  ta-integration-properties-file
  exit 1
fi

if [ ! -f $2 ]; then
   echo File $2 was not found
   exit 1
fi

echo Deleting current secrets....
kubectl delete secret --namespace=$1 --ignore-not-found ta-integration-properties '--cascade=false'

echo Adding secrets....
kubectl create secret generic ta-integration-properties --namespace=$1 --from-file=$2
