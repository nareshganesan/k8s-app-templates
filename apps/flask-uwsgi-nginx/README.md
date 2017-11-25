# Building a flask-uwsgi-nginx 

This is a flask app for RAD. Some of the features about the template 

- HTTPS with HSTS enabled - TODO: rewrite using kube-lego (letsencrypt ssl)
- Alpine image for light weight serving.
- uWSGI server - with loads of configuration 

> Note: A bit of Docker, Nginx, uwsgi, Python, Flask is a prerequisite. 
> I've made a descriptive steps to use the template. Feel free to raise an issue. 

## Installation & Setup

```bash
$ git clone https://github.com/nareshganesan/kubernetes-practice.git
```

> Note: Dependencies 
> requires a mysql database to be up and running before starting the app.
> Environmental variables about mysql has to be passed while running the app

```bash
# MySQL database dependeny

# create guestbook database
$ mysql> create database guestbook;

# create message table in guestbook db
$ mysql> create table message ( int id auto_increment not null, name varchar(300), primary key (id) );
```

### 1. Build & run the flaskapp docker image
```bash
$ cd kubernetes-practice/apps/flask-uwsgi-nginx;

# build the app
$ docker build -t flask-uwsgi .

# run the app
$ docker run -d -p -e MYSQL_HOST='xxx.xxx.xxx.xx' -e MYSQL_PORT=3306 -e MYSQL_USER='root' -e MYSQL_PASSWORD='password' -e MYSQL_DATABASE='guestbook'  80:80 flask-uwsgi

# MYSQL_HOST - host dns record or ip
# MYSQL_PORT - host port
# MYSQL_USER - database username
# MYSQL_PASSWORD - database password
# MYSQL_DATABASE - database name

# Output from docker setup.
$ curl -k http://localhost

# Test with user parameter
$ curl -k http://localhost/?user=username
# Should display the following in the screen.
# output:
{
  "code": 200,
  "message": "Greetings username! \n This is a flask template bundled with uwsgi reverse proxied behind nginx.(host: flask-uwsgi-nginx-6769c7cd7d-drgrs)",
  "status": "OK"
}

# Test to list message
$ curl -k https://localhost/msg?search=xx
# if you have few data in the db
# output:
{
  "data": [
    {
      "id": "1",
      "name": "first message"
    },
    {
      "id": "2",
      "name": "second message"
    }
  ],
  "message": "message found for id <built-in function id>",
  "status": "OK"
}

```
### 2. Kubernetes way to run flaskapp

> Note: add mysql database env variables in the flask-uwsgi-nginx-deployment.yaml.
> Note: just run the mysql app from the apps/mysql folder and sit back and relax.

```bash
# kubernetes setup
$ cd kubernetes-practice/apps/mysql;

# both flask and mysql app runs in namespace: project-name
# make sure you have a persistent volume of 10g. You could edit the yaml file if you have lesser or more storage.
# run mysql app
$ kubectl apply -f mysql-app-service.yaml

# change dir to flask app dir
$ cd kubernetes-practice/apps/flask-uwsgi-nginx;

# run the app
$ kubectl apply -f flask-uwsgi-nginx-deployment.yaml

# test the app
# here: project-name is the namespace hardcoded in the yaml. change it your preference.
$ kubectl -n project-name get svc | grep IP:
IP:                xx.xx.xx.xxx

# you will get different value for yours, copy it.
# the following will hit the service end point.
$ while true; do curl http://xx.xx.xx.xxx/; sleep 2; done

# Test with user parameter
$ curl -k http://xx.xx.xx.xxx/?user=username
# Should display the following in the screen.
# output:
{
  "code": 200,
  "message": "Greetings username! \n This is a flask template bundled with uwsgi reverse proxied behind nginx.(host: flask-uwsgi-nginx-6769c7cd7d-drgrs)",
  "status": "OK"
}

# the host in the output keeps changing indicating the response is from differnet pods, all managed by kuberenetes!!!

# Test to list message
$ curl -k http://xx.xx.xx.xxx/msg?search=xx
# if you have few data in the db
# output:
{
  "data": [
    {
      "id": "1",
      "name": "first message"
    },
    {
      "id": "2",
      "name": "second message"
    }
  ],
  "message": "message found for id <built-in function id>",
  "status": "OK"
}


```

## TODO
- [ ] lets encrypt support should be enabled from kubernetes layer


