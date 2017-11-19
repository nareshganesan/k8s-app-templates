# Kubernetes practice ( :construction: WIP )

I'm a newbie trying to make my way around Kubernetes, I've been learning and documenting the work. 
For kubernetes installation, I've been using either kubeadm or minikube for all the experiments.
Please feel free to leave a comment or raise an issue here.

- [x] Dashboard
- [x] Monitoring - Heapster
- [ ] Ingress controller - nginx-ingress-controller / traefik ingress controller
- [ ] Auto TLS provisioning - lets encrypt
- [ ] Persistant volume - Rook


> Note: All the scripts have been tested only on Ubuntu 16.04 (Xenial Xerus), Kubernetes v1.8.1, kubeadm v1.8.1.

## Installation (Kubernetes-Ubuntu-Baremetal)

```bash
$ git clone https://github.com/nareshganesan/kubernetes-practice.git
$ git checkout -b dev origin/dev; cd setup;
$ sudo bash setup/install.bash
```

## Setup
To setup a kubernetes cluster:
```bash
$ sudo bash start.bash -n node_type
# n - master / node
# t (optional) - token to join an existing kubernetes cluster
# i (optional) - master ip address (host:port) of cluster
# d (optional) - discovery token to join the cluster
```


## Application development
This is the most fun part of kubernetes, where we simply template the apps, deploy it inside containers, wrap it in service and expose it to outside world. 
Once we deploy an app as service, kubernetes takes care of the scaling, redundancy management and monitoring the apps.

```bash
# apps/ - folder contains quick start template for well known tools.  
```

To know more about the app templates, [see](https://github.com/nareshganesan/kubernetes-practice/tree/dev/apps)

## TODO
- [ ] Kubernetes Dashboard
- [ ] RBAC custom webhook authentication (Github Auth)
- [ ] Custom Authorization for resource types 
- [ ] Load balancer config automation
- [ ] Custom cluster creation template (YAML's)
- [ ] Auto backup configs, secrets, data to cloud object store. (S3, Cloud Storage, Azure Storage, Digital Ocean object storage)
- [ ] CI
- [ ] CPU / Memory monitoring (Heapster)

## TODO:app templates

#### Servers 
- [ ] nginx
- [ ] apache
- [ ] tornado
- [ ] uwsgi

#### static
- [ ] Hugo
- [ ] Jekyll
- [ ] Drupal
- [ ] Wordpress

#### Applications
- [x] flask
- [ ] go-gin
- [ ] django
- [ ] Elixir
- [ ] Phoenix
- [ ] Laravel
- [ ] Php-slim
- [ ] Symfony

#### Distributed tools
- [ ] celery
- [ ] nsq
- [ ] apache-spark
- [ ] apache-kafka

#### DB (single, cluster)
- [ ] MySQL
- [ ] Postgres
- [ ] MariaDB
- [ ] Cassandra
- [ ] ElasticSearch
- [ ] MongDB
- [ ] Redis

#### Object storage
- [ ] minio


:tada: :sparkles: :boom: this is going to be a fun project.

