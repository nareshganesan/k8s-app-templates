# Building a flask-uwsgi-nginx 

:construction: WIP

This is a flask app for RAD. Some of the features about the template 

- HTTPS with HSTS enabled - TODO: rewrite using kube-lego (letsencrypt ssl)
- Alpine image for light weight serving.
- uWSGI server - with loads of configuration 

> Note: A bit of Docker, Nginx, uwsgi, Python, Flask is a prerequisite. 
> I've made a descriptive steps to use the template. Feel free to raise an issue. 

## Installation

```bash
$ git clone https://github.com/nareshganesan/kubernetes-practice.git

```

## Setup
Build & run docker image
```bash
$ cd kubernetes-practice/apps/flask-uwsgi-nginx;

# build the app
$ docker build -t flask-uwsgi .

# run the app
$ docker run -d -p 80:80 flask-uwsgi

# To test the docker setup
$ curl -k https://localhost

# Test with user parameter
$ curl -k https://localhost/?user=yourname

# Should display the following in the screen.
# output:
{
  "code": 200, 
  "message": "Greetings anonymous! \n This is a flask template bundled with uwsgi reverse proxied behind nginx.(host: flask-uwsgi-nginx-6769c7cd7d-drgrs)", 
  "status": "OK"
}

# kubernetes setup
$ cd kubernetes-practice/apps/flask-uwsgi-nginx;

# run the app
$ kubectl apply -f flask-uwsgi-nginx-deployment.yaml

# test the app
# here: project-name is the namespace hardcoded in the yaml. change it your preference.
$ kubectl -n project-name get svc | grep IP:
IP:                10.98.41.197

# you will get different value for yours, copy it.
# the following will hit the service end point.
$ while true; do curl http://10.98.41.197/; sleep 2; done


# the host in the output keeps changing indicating the response is from differnet pods, all managed by kuberenetes!!!

```

## TODO
- [ ] lets encrypt support should be enabled from kubernetes layer


