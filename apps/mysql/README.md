## To create a mysql pod in your cluster

> if you already have a PV ignore the next command

```bash
# this will create a pv in your cluster
$ kubectl apply -f mysql-pv-local.yaml
```

## install mysql

```bash
# will create a mysql pod running in namespace: project-name
$ kubectl apply -f mysql-deployment.yaml
```

## connect to database
```bash
# connect to newly created mysql server
$ kubectl -n project-name run -it --rm --image=mysql:5.6 --restart=Never mysql-client -- mysql -h mysql -ppassword
```

## Clean up 
```bash

$ kubectl delete -f mysql-deployment.yaml
```
