# Building a flask-uwsgi-nginx 

:construction: WIP

This is a flask app for RAD. Some of the features about the template 

- HTTPS with HSTS enabled.
- Alpine image for light weight serving.
- uWSGI server - with loads of configuration 

> Note: A bit of Docker, Nginx, uwsgi, Python, Flask is a prerequisite. 
> I've made a descriptive steps to use the template. Feel free to raise an issue. 

## Installation

```bash
$ git clone https://github.com/nareshganesan/kubernetes-practice.git
$ git checkout -b dev origin/dev

```

## Setup
Build & run docker image
```bash
$ cd apps/flask-uwsgi;

# build the app
$ docker build -t flask-uwsgi .

# run the app
$ docker run -d -p 443:443 flask-uwsgi

# To test the setup
$ curl -k https://localhost

# Test with user parameter
$ curl -k https://localhost/?user=yourname

# Should display the following in the screen.
# output:
{
  "status": "OK",
  "message": "Greetings anonymous! 
  This is a flask template with bundled with uwsgi reverse proxied behind nginx.",
  "code": 200
}

```

## TODO
:x: kubernetes deployment yaml
:x: lets encrypt support should be enabled from kubernetes layer


