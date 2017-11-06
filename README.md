# Kubernetes practice 

I'm a newbie trying to make my way around Kubernetes, I've been learning and documenting the work. 
For kubernetes installation, I've been using either kubeadm or minikube for all the experiments.
Please feel free to leave a comment or raise an issue here.

> Note: All the scripts have been tested only on Ubuntu 16.04 (Xenial Xerus).

## Installation (Kubernetes-Ubuntu-Baremetal)

```bash
git clone https://github.com/nareshganesan/kubernetes-practice.git
git checkout -b dev origin/dev
sudo bash setup/install.bash
```

## Setup
To setup a kubernetes cluster:
```bash
sudo bash start.bash -u username -n node_type
# u - username of the application user to use kubectl
# n - master / node
# t (optional) - token to join an existing kubernetes cluster
```

## Application development
This is the most fun part of kubernetes, where we simply template the apps, deploy it inside containers, wrap it in service and expose it to outside world. 
Once we deploy an app as service, kubernetes takes care of the scaling, redundancy management and monitoring the apps.
