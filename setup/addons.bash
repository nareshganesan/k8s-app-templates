# lists some of the useful addons for Kubernetes

# addon: helm & tiller
# please use stable version, here I'm using a latest master version
curl https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get | bash
helm init

# add tiller roles and rolebindings
kubectl -n kube-system create sa tiller
kubectl create clusterrolebinding tiller --clusterrole=cluster-admin --serviceaccount=kube-system:tiller
kubectl -n kube-system patch deploy/tiller-deploy -p '{"spec": {"template": {"spec": {"serviceAccountName": "tiller"}}}}'



# TODO: addon: kube-lego - (auto https cert renewal using letsencrypt)
# ref: https://github.com/jetstack/kube-lego

