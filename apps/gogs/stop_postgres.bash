# delete postgres

# delete statefulset
kubectl delete -f ./k8s/02-postgres-statefulset.yaml

sleep 2

# delete pv 
kubectl delete -f ./k8s/01-psql-pv-local.yaml

# delete postgres secrets
kubectl delete -f ./k8s/01-postgres-secret.yaml

# delete postgres configmaps
kubectl delete -f ./k8s/01-postgres-configmap.yaml

# delete postgres sql
kubectl delete -f ./k8s/01-psql-sql-files.yaml

# delete psql seed script
kubectl delete -f ./k8s/01-psql-seed-script-configmap.yaml
