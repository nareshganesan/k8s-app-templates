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

if ( ! getopts "h:n:t" opt); then
	usage "-n <node type is required>
    -t (optional) cluster token
    -i (optional) master ip address (host:port)
    -d (optional) discovery token" >&2;
	exit 1;
fi

while getopts "h:n:t:d:i:" o; do
    case "${o}" in
        n)
            node_type=${OPTARG}
            ;;
        t)
            token=${OPTARG}
            ;;
	d)
	    disc_token=${OPTARG}
	    ;;
	i)
	    master_ip=${OPTARG}
	    ;;
        h) usage "-n <node type is required> 
    -t (optional) cluster token
    -i (optional) master ip address (host:port)
    -d (optional) discovery token" >&2;
            exit 0;;
        \?) usage "-n <node type is required> 
    -t (optional) cluster token
    -i (optional) master ip address (host:port)
    -d (optional) discovery token" >&2;
            exit 1;;
        :)
            echo "Option -$OPTARG requires an argument." >&2
            exit 1;;
    esac
done

if [ ! "$node_type" ]
then
     usage "-n <node type is required> 
    -t (optional) cluster token
    -i (optional) master ip address (host:port)
    -d (optional) discovery token" >&2;
        exit 1;
fi

# script variables
# get the user running sudo script
user=$(who | awk '{print $1}');


echo "User: "$user;
if [ $node_type == "master" ]; then
    echo "Kubernetes cluster: master setup"
    kubeadm reset;
    kubeadm init --pod-network-cidr=10.244.0.0/16 | tee kubeadm_output.txt
    cluster_token=$(grep -oP '(?<=\-\-token).*(?=192)' kubeadm_output.txt)
    cluster_token=$(echo $cluster_token);
    join_token=`sudo kubeadm token create --ttl 0 --description "custom join token never ending ttl"`;
    discovery_token=$(grep -oP "\-\-discovery-token-ca-cert-hash\K.*" kubeadm_output.txt)
    discovery_token=$(echo $discovery_token);
    tmp_data=$(grep -oP '(?<=\-\-token).*(?=discovery-token-ca-cert-hash)' kubeadm_output.txt | xargs)
    tmp_data=($tmp_data)
    master_ip="${tmp_data[1]}"
    echo "cluster token: "$cluster_token
    echo "join token: "$join_token
    echo "discovery-token-ca-cert-hash: "$discovery_token
    echo "join nodes to the cluster using the following steps..."
    echo "git clone https://github.com/nareshganesan/kubernetes-practice.git; cd kubernetes-practice/setup;"
    echo "sudo bash start.bash -n node -t "$join_token" -i "$master_ip" -d "$discovery_token;
    su - $user -c 'mkdir -p $HOME/.kube';
    su - $user -c 'echo "$HOME/.kube/config"' | xargs -i cp /etc/kubernetes/admin.conf {};
    chown -R $user:$user $HOME/.kube/config;

    # Apply addons

    # install necessary addons
    # Note: access addons from proxy.

    # addon: weave
    kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')"

    # addon: dashboard
    # proxy url: http://localhost:8001/api/v1/namespaces/kube-system/services/https:kubernetes-dashboard:/proxy/
    kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/master/src/deploy/recommended/kubernetes-dashboard.yaml

    # addon: heapster
    # proxy url: http://localhost:8001/api/v1/namespaces/kube-system/services/monitoring-grafana/proxy
    kubectl apply -f https://raw.githubusercontent.com/kubernetes/heapster/master/deploy/kube-config/influxdb/grafana.yaml
    kubectl apply -f https://raw.githubusercontent.com/kubernetes/heapster/master/deploy/kube-config/influxdb/heapster.yaml
    kubectl apply -f https://raw.githubusercontent.com/kubernetes/heapster/master/deploy/kube-config/influxdb/influxdb.yaml
    kubectl apply -f https://raw.githubusercontent.com/kubernetes/heapster/master/deploy/kube-config/rbac/heapster-rbac.yaml

    # TODO: addon: kube-lego - (auto https cert renewal using letsencrypt)
    # ref: https://github.com/jetstack/kube-lego

    exit 0;
else
   echo "Kubernetes cluster: node setup";
   # To ensure hostname uniquesness
   # TODO: need to way to generate node names
   # vim /etc/hostname
   # vim /etc/hosts
   # hostnamectl set-hostname node1   
   if [ -z "$token" ]; then
       echo "cluster token is not set!";
       usage "-t (optional) cluster token" >&2;
       exit 1;
   fi
   if [ -z "$disc_token" ]; then
       echo "discovery token is not set!";
       usage "-d (optional) discovery token" >&2;
       exit 1;
   fi
   if [ -z "$master_ip" ]; then
       echo "master ip (host:port) is required cluster node setup"
       usage "-i (optional) master ip address (host:port)"
       exit 1;
   fi
   kubeadm reset;
   echo "master ip: "$master_ip;
   echo "cluster join token: "$token;
   echo "discovery token: "$disc_token;

   kubeadm join --token $token $master_ip --discovery-token-ca-cert-hash $disc_token;
   exit 0;
fi

