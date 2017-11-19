### Php redis guestbook

> Note: The following example assumes you have a kubernetes cluster up and running.

> Ref: https://kubernetes.io/docs/tutorials/stateless-application/guestbook/

### To install the app

```bash
# create the redis master pod deployment for the app
kubectl apply -f redis-master-deployment.yaml
```

```bash
# create redis master as service for the app
kubectl apply -f redis-master-service.yaml
```

```bash
# create redis slave pod deployment for the app
kubectl apply -f redis-slave-deployment.yaml
```

```bash
# create redis slave as service for the app
kubectl apply -f redis-slave-service.yaml
```

```bash
# create frontend pod deployment for the app
kubectl apply -f frontend-deployment.yaml
```

```bash
# create frontend service for the app
kubectl apply -f frontend-service.yaml
```

### cleanup 

```bash
# to clean up php-redis guestbook app
bash cleanup.bash
```
