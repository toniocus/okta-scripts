# Deploy services
kubectl apply '--namespace=sit01' -f /home/jenkins/workspace/sit01_project_nonprod_ta/ta-aws-api-ta-develop-299-kubernetes.yml
kubectl scale deployment ta-aws-api '--replicas=1' '--namespace=sit01'

# Expose service
kubectl label services ta-aws-api 'expose=true' '--namespace=sit01' --overwrite

kubectl annotate services --overwrite '--namespace=sit01' ta-aws-api 'fabric8.io/ingress.annotations=kubernetes.io/ingress.class: nginx-external'

sleep 20s
kubectl delete ingress ta-aws-api -n sit01

sleep 45s
kubectl annotate ingress ta-aws-api 'nginx.ingress.kubernetes.io/auth-type=basic' '--namespace=sit01' --overwrite

kubectl annotate ingress ta-aws-api 'nginx.ingress.kubernetes.io/auth-secret=basic-auth-secret' '--namespace=sit01' --overwrite
