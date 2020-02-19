

beforeLast=$(($# -1))
SERVICE=${@:$beforeLast:1}   # last - 1 param the service
URLPATH=${@:$#}           # the URL path without / at the beginning

PARAMS=${@:1:$(($# -2))} # all params except the last


URL=$(minikube service $SERVICE --url)

echo "curl $PARAMS -H 'Content-Type: application/json' -X POST $URL/$URLPATH"
curl $PARAMS -H 'Content-Type: application/json' -X POST $URL/$URLPATH

echo
