
# create statefulset
kubectl delete -f ./k8s/02-postgres-statefulset.yaml

kubectl delete -f ./k8s/03-gogs-statefulset.yaml

sleep 2

# create configmaps
kubectl delete -f ./k8s/01-gogs-ini-configmap.yaml

# create tmpl configmaps
kubectl delete -f ./k8s/01-gogs-ini-tmpl-configmap.yaml

sleep 2

# create pv
kubectl delete -f ./k8s/01-gogs-pv-local.yaml

# create postgres

# create postgres secrets
kubectl delete -f ./k8s/01-postgres-secret.yaml

# create postgres configmaps
kubectl delete -f ./k8s/01-postgres-configmap.yaml

# create postgres sql
kubectl delete -f ./k8s/01-psql-sql-files.yaml

# create psql seed script
kubectl delete -f ./k8s/01-psql-seed-script-configmap.yaml

sleep 2

# create pv 
kubectl delete -f ./k8s/01-psql-pv-local.yaml

