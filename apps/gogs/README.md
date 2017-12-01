# Gogs Deployment with PostgreSQL on Kubernetes

[Gogs](https://gogs.io) is a [painless self-hosted Git service.](https://github.com/gogits/gogs/tree/master)

[PostgreSQL](https://www.postgresql.org/) is an [advanced object-relational database management system](https://github.com/postgres/postgres) that supports an extended subset of the SQL standard, including transactions, foreign keys, subqueries, triggers, user-defined types and functions.

# Deploying Gogs and Postgres

## Quickstart

`kubectl apply -f ./k8s`

## Port forwarding

Once the pods are created, forward port 3000 (or any other) on your local machine to port 3000 of the `gogs` pod to make the web UI accessible in your browser. Two users will already be available, `gogs` (which has an example repository created as well and is intended to be used by you for instant exploring and [drone.io continuous integration and deployment](https://github.com/stevenaldinger/k8s-drone)) and `drone` which is intended to work as a service account.

`kubectl port-forward gogs-0 -n vcs 3000:3000`

Navigate to [http://localhost:3000](http://localhost:3000) to begin using your new `Gogs` git service.

### Users

```
user: gogs
pass: gogs
email: gogs@gogs.io

user: drone
pass: drone
email: drone@drone.io
```

### Credits 

gogs-postgres app is a complete ripoff from [steve's repo](https://github.com/stevenaldinger/k8s-gogs). I have made some corrections here, will share with him once the changes are good enough for a PR.

[stevenaldinger](https://github.com/stevenaldinger)
