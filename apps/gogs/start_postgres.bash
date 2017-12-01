# create postgres

# create postgres secrets
kubectl apply -f ./k8s/01-postgres-secret.yaml

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

