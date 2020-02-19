SERVICE=${SERVICE:="ta-comptel-callback"}
NS=${NS:="sit01"}

echo "Exposing service=$SERVICE (from SERVICE env variable), to namespace=$NS (from NS env var)"
echo "Hit [ENTER] to continue"
read kk

# Expose service
echo "annotations...."
kubectl label services $SERVICE "expose=true" "--namespace=$NS" --overwrite

kubectl annotate services --overwrite --namespace=$NS $SERVICE "fabric8.io/ingress.annotations=kubernetes.io/ingress.class: nginx-external"

echo "delete...."
sleep 40s
kubectl delete ingress $SERVICE -n $NS

echo "authentication...."
sleep 40s
kubectl annotate ingress $SERVICE "nginx.ingress.kubernetes.io/auth-type=basic" "--namespace=$NS" --overwrite

kubectl annotate ingress $SERVICE "nginx.ingress.kubernetes.io/auth-secret=basic-auth-secret" "--namespace=$NS" --overwrite


# PRE OKTA Stuff
#echo "annotations...."
#kubectl --context admin-cluster annotate services --overwrite --namespace=$NS $SERVICE fabric8.io/expose=true
#
#
#echo "labels...."
#kubectl --context admin-cluster label services $SERVICE expose=true --namespace=$NS --overwrite
#
#echo "authentication...."
#sleep 5
#kubectl --context admin-cluster annotate ingress $SERVICE nginx.ingress.kubernetes.io/auth-type=basic --namespace=$NS --overwrite
#kubectl --context admin-cluster annotate ingress $SERVICE nginx.ingress.kubernetes.io/auth-secret=basic-auth-secret --namespace=$NS --overwrite

