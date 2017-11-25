## To create a mysql pod in your cluster

> if you already have a PV skip the next command

```bash
# this will create a pv in your cluster
$ kubectl apply -f mysql-pv-local.yaml
```

## install mysql

> Note: mysql deployment is configured to run in namespace: project-name. 
> please make sure its available

```bash
# To create project-name namespace
$ kubectl apply -f mysql-namespace.yaml
```

```bash
# will create a mysql pod running in namespace: project-name
$ kubectl apply -f mysql-app-service.yaml
```

## connect to database
```bash
# connect to newly created mysql server
$ kubectl -n project-name run -it --rm --image=mysql:5.6 --restart=Never mysql-client -- mysql -h mysql -u root -ppassword
```

## Clean up 
```bash
$ kubectl delete -f mysql-app-service.yaml
```
