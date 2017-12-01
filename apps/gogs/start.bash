
# create ns
kubectl apply -f./k8s/00-vcs-namespace.yaml

# create secrets
kubectl apply -f ./k8s/01-postgres-secret.yaml

# create configmaps
kubectl apply -f ./k8s/01-gogs-ini-configmap.yaml

# create tmpl configmaps
kubectl apply -f ./k8s/01-gogs-ini-tmpl-configmap.yaml

sleep 2

# create pv
kubectl apply -f ./k8s/01-gogs-pv-local.yaml

# create postgres

# create postgres configmaps
kubectl apply -f ./k8s/01-postgres-configmap.yaml

# create postgres sql
kubectl apply -f ./k8s/01-psql-sql-files.yaml

# create psql seed script
kubectl apply -f ./k8s/01-psql-seed-script-configmap.yaml

sleep 2

# create pv 
kubectl apply -f ./k8s/01-psql-pv-local.yaml

sleep 2

# create statefulset
kubectl apply -f ./k8s/02-postgres-statefulset.yaml

kubectl apply -f ./k8s/03-gogs-statefulset.yaml
