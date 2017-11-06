#!/bin/bash


err_report() {
    echo "Error on line $1"
}

trap 'err_report $LINENO' ERR

usage() {
    echo "Usage: $0

Options:
    $1" 1>&2;
    exit 1;
}


force_create=0;

if ( ! getopts "h:n:u:t" opt); then
	usage "-u <user name is required>
    -n <node type is required>
    -t (optional) cluster token" >&2;
	exit 1;
fi

while getopts "h:n:u:t" o; do
    case "${o}" in
        u)
            user=${OPTARG}
            ;;
        n)
            node_type=${OPTARG}
            ;;
        t)
            token=${OPTARG}
            ;;
        h) usage "-u <user name is required> 
    -n <node type is required> 
    -t (optional) cluster token" >&2;
            exit 0;;
        \?) usage "-u <user name is required> 
    -n <node type is required> 
    -t (optional) cluster token" >&2;
            exit 1;;
        :)
            echo "Option -$OPTARG requires an argument." >&2
            exit 1;;
    esac
done

if [ ! "$user" ] || [ ! "$node_type" ]
then
     usage "-u <user name is required> 
    -n <node type is required> 
    -t (optional) cluster token" >&2;
        exit 1;
fi


# echo "Root User: "$USER
# echo "Home dir: "$HOME

# su - $user -c 'echo  "User: "${USER}'
# su - $user -c 'echo "Home dir: "${HOME}'


if [ $node_type == "master" ]; then
    echo "Kubernetes cluster setup: master"
    su - $user -c 'echo "User: "${USER}';
    kubeadm reset;
    kubeadm init --pod-network-cidr=10.244.0.0/16 | tee kubeadm_output.txt
    # cluster_token==$(grep -oP "\-\-token\K.*" kubeadm_output.txt)
    cluster_token=$(grep -oP '(?<=\-\-token).*(?=192)' kubeadm_output.txt)
    cluster_token=$(echo $cluster_token);
    discovery_token=$(grep -oP "\-\-discovery-token-ca-cert-hash\K.*" kubeadm_output.txt)
    discovery_token=$(echo $discovery_token);
    echo "token: "$cluster_token
    echo "discovery-token-ca-cert-hash: "$discovery_token
    # if [ $? == 0 ]; then
       # echo "\n";
       # echo "discovery token ca-cert: "$?;
    # fi;
    su - $user -c 'mkdir -p $HOME/.kube';
    su - $user -c 'echo "$HOME/.kube/config"' | xargs -i cp /etc/kubernetes/admin.conf {};
    su - $user -c 'chown $(id -u):$(id -g) $HOME/.kube/config';
    # Apply addons

    # install flannel network config
    kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/v0.9.0/Documentation/kube-flannel.yml
    exit 0;
else
   echo "Kubernetes cluster setup: node";
   if [ -z "$token" ]; then
       echo "cluster token is not set!";
       usage "-t (optional) cluster token" >&2;
       exit 1;
   else
       kubeadm reset;
       kubeadm join --token $token;
      exit 0;
   fi
fi

