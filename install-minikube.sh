
version="v0.22.3"

echo "Installing minikube $version...."

curl -Lo /tmp/minikube https://storage.googleapis.com/minikube/releases/$version/minikube-linux-amd64 \
        && chmod +x /tmp/minikube               \
        && sudo mv /tmp/minikube /u/ta/bin
