if [[ ! $PS1 =~ "(ta)" ]] 
then 

  echo "Setting Telecom Arg environment....."

  PATH=$TA_HOME/bin:$TA_HOME/maven/bin:$PATH
  source jdk8

  PS1="(ta)$PS1"

  source <(kubectl completion bash | sed 's/kubectl/kaws/g')
  source <(kubectl completion bash)
  source $TA_HOME/bin/okta-cli.sh


#  export AWS_PROFILE=thor
  export KUBECONFIG=$HOME/.kube/okta-config
  export ACCOUNT=625811157828
  export AWS_PROFILE=tools-vlocity

  alias kaws='kubectl --namespace sit01'
  alias pods='kaws get pods -w -l group=ar.com.telecom.om -L version '

# Vlocity Tools
vloc-tools () {
        docker run --rm -it -v $(pwd):/workdir vlocity/vloc-tools:latest $@
}

else

  echo "Already running in a Telecom Arg environment !!!!!"

fi
