#!/bin/bash

#Install Base docker-engine
sed -i 's/http:\/\/us./http:\/\//g' /etc/apt/sources.list
apt-get update
apt-get remove docker docker-engine
apt-get -y install \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common socat
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
apt-key fingerprint 0EBFCD88
add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
apt-get update
apt-get -y install docker-ce=17.03.2~ce-0~ubuntu-xenial 
# apt-get -y install nfs-kernel-server nfs-common
groupadd docker
usermod -aG docker $USER
systemctl enable docker

# test

# docker images 
# docker login

#########################################################################################

# Note: If there is error with docker login or tcp timout error
echo "nameserver 8.8.8.8" >> /etc/resolvconf/resolv.conf.d/head
echo "nameserver 8.8.4.4" >> /etc/resolvconf/resolv.conf.d/head

resolvconf -u

#########################################################################################

# Install Kubernetes Base

# apt-get update && apt-get install -y apt-transport-https
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
touch /etc/apt/sources.list.d/kubernetes.list
#bash -c 'echo "deb http://apt.kubernetes.io/ kubernetes-xenial-1.7 main" > /etc/apt/sources.list.d/kubernetes.list'
bash -c 'echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" > /etc/apt/sources.list.d/kubernetes.list'
apt-get update
apt-get install -y --allow-unauthenticated kubelet=1.7.10-00 kubeadm=1.7.10-00 kubectl=1.7.10-00 kubernetes-cni=0.5.1-00

# Note: apt-get -y install docker-engine
# As of release Kubernetes 1.7.10, kubelet will not work with enabled swap.
# https://github.com/kubernetes/kubernetes/issues/53333
# echo 'Environment="KUBELET_EXTRA_ARGS=--fail-swap-on=false --cgroup-driver=cgroupfs"' >> /etc/systemd/system/kubelet.service.d/10-kubeadm.conf
grep -n "Environment=" /etc/systemd/system/kubelet.service.d/10-kubeadm.conf | tail -n1 | cut -d: -f1 | xargs -I '{}' sed -i '{} a Environment="KUBELET_EXTRA_ARGS=--fail-swap-on=false --cgroup-driver=cgroupfs"' /etc/systemd/system/kubelet.service.d/10-kubeadm.conf
systemctl daemon-reload
systemctl restart kubelet

#########################################################################################
