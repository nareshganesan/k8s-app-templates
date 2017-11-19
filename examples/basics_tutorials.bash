#!/bin/bash

## https://kubernetes.io/docs/tutorials/kubernetes-basics/

### Creating a Cluster

# to get cluster information
kubectl cluster-info

# get nodes in the cluster
kubectl get nodes

### Create a Deployment

# run command creates a new deployment
# requires deployment name, app image location --image, --port
kubectl run kubernetes-bootcamp --image=docker.io/jocatalin/kubernetes-bootcamp:v1 --port=8080

# list your deployments in the cluster
kubectl get deployments

# a proxy that will forward communications into the cluster-wide, private network
# see all those APIs hosted through the proxy endpoint
kubectl proxy

# see all those APIs hosted through the proxy endpoint
curl http://localhost:8001/version

# get the Pod name
export POD_NAME=$(kubectl get pods -o go-template --template '{{range .items}}{{.metadata.name}}{{"\n"}}{{end}}')
echo Name of the Pod: $POD_NAME

# make an HTTP request to the application running in that pod
# url is the route to the API of the Pod
curl http://localhost:8001/api/v1/proxy/namespaces/default/pods/$POD_NAME/

### Exploring Your App

# look for existing Pods
kubectl get pods

# to view what containers are inside that Pod and what images are used to build those containers
# details about the Pod’s container: IP address, the ports used and a list of events related 
# to the lifecycle of the Pod
kubectl describe pods

# Anything that the application would normally send to STDOUT becomes logs for the container within the Pod
kubectl logs $POD_NAME

# execute commands directly on the container once the Pod is up and running
# Let’s list the environment variables
kubectl exec $POD_NAME env

#  let’s start a bash session in the Pod’s container
kubectl exec -ti $POD_NAME bash

# open the source code of the app is in the server.js 
cat server.js

# check that the application is up by running a curl 
curl localhost:8080

# to close container connection
exit

### Exposing Your App to public

# let’s list the current Services from our cluster:
kubectl get services

# create a new service and expose it to external traffic we’ll use the expose command with NodePort as parameter
kubectl expose deployment/kubernetes-bootcamp --type="NodePort" --port 8080

# check again for the services
kubectl get services

# To find out what port was opened externally (by the NodePort option) 
kubectl describe services/kubernetes-bootcamp

# Create an environment variable called NODE_PORT that has as value the Node port
export NODE_PORT=$(kubectl get services/kubernetes-bootcamp -o go-template='{{(index .spec.ports 0).nodePort}}')
echo NODE_PORT=$NODE_PORT

# test that the app is exposed outside of the cluster using  curl & 
# the IP of the Node and the externally exposed port
# we get a response from the server. The Service is exposed
curl host01:$NODE_PORT

# Deployment created automatically a label for our Pod
# describe deployment command you can see the name of the label
kubectl describe deployment

# Let’s use this label to query our list of Pods
kubectl get pods -l run=kubernetes-bootcamp

# do the same to list the existing services
kubectl get services -l run=kubernetes-bootcamp

# To apply a new label we use the label command followed by the object type, object name and the new label:
# apply a new label to our Pod (we pinned the application version to the Pod),
kubectl label pod $POD_NAME app=v1

# check it with the describe pod command
kubectl describe pods $POD_NAME

# label is attached now to our Pod. And we can query now the list of pods using the new label
kubectl get pods -l app=v1

# To delete Services you can use the delete service
kubectl delete service -l run=kubernetes-bootcamp

# Confirm that the service is gone
kubectl get services

# To confirm that route is not exposed anymore you can curl the previously exposed IP and port
curl host01:$NODE_PORT

# You can confirm that the app is still running with a curl inside the pod
kubectl exec -ti $POD_NAME curl localhost:8080


### Scale your app

# list your deployments
kubectl get deployments

# We should have 1 Pod. If not, run the command again. This shows:
# The DESIRED state is showing the configured number of replicas
# The CURRENT state show how many replicas are running now
# The UP-TO-DATE is the number of replicas that were updated to match the desired (configured) state
# The AVAILABLE state shows how many replicas are actually AVAILABLE to the users
# let’s scale the Deployment to 4 replicas
kubectl scale deployments/kubernetes-bootcamp --replicas=4

# check the deployments
#  change was applied, and we have 4 instances of the application available
kubectl get deployments

# There are 4 Pods now, with different IP addresses
kubectl get pods -o wide

# To check that, use the describe command
kubectl describe deployments/kubernetes-bootcamp

# Let’s check that the Service is load-balancing the traffic. 
# To find out the exposed IP and Port we can use the describe service
kubectl describe services/kubernetes-bootcamp

# Create an environment variable called NODE_PORT that has as value the Node port
export NODE_PORT=$(kubectl get services/kubernetes-bootcamp -o go-template='{{(index .spec.ports 0).nodePort}}')
echo NODE_PORT=$NODE_PORT

# curl to the the exposed IP and port. Execute the command multiple times
# We hit a different Pod with every request. This demonstrates that the load-balancing is working
curl host01:$NODE_PORT

# To scale down the Service to 2 replicas, run again the scale command:
kubectl scale deployments/kubernetes-bootcamp --replicas=2

# List the Deployments to check if the change was applied
kubectl get deployments

# List the number of Pods
# This confirms that 2 Pods were terminated
kubectl get pods -o wide


### Updating Your App

# list your deployments
kubectl get deployments

# list the running Pods
kubectl get pods

# To view the current image version of the app, run a describe command against the Pods (look at the Image field)
kubectl describe pods

# To update the image of the application to version 2, use the set image command, 
# followed by the deployment name and the new image version
# The command notified the Deployment to use a different image for your app and initiated a rolling update
kubectl set image deployments/kubernetes-bootcamp kubernetes-bootcamp=jocatalin/kubernetes-bootcamp:v2

# Check the status of the new Pods, and view the old one terminating with the get pods command
kubectl get pods

# let’s check that the App is running. To find out the exposed IP and Port we can use describe service
kubectl describe services/kubernetes-bootcamp

# Create an environment variable called NODE_PORT that has as value the Node port
export NODE_PORT=$(kubectl get services/kubernetes-bootcamp -o go-template='{{(index .spec.ports 0).nodePort}}')
echo NODE_PORT=$NODE_PORT

# we’ll do a curl to the the exposed IP and port
# We hit a different Pod with every request and we see that all Pods are running the latest version (v2).
curl host01:$NODE_PORT

# The update can be confirmed also by running a rollout status command:
kubectl rollout status deployments/kubernetes-bootcamp

# To view the current image version of the app, run a describe command against the Pods
# We run now version 2 of the app 
kubectl describe pods

## Rollback update

# Let’s perform another update, and deploy image tagged as v10
kubectl set image deployments/kubernetes-bootcamp kubernetes-bootcamp=jocatalin/kubernetes-bootcamp:v10

# Use get deployments to see the status of the deployment
kubectl get deployments

# something is wrong… We do not have the desired number of Pods available. List the Pods again
kubectl get pods

# A describe command on the Pods should give more insights
# There is no image called v10 in the repository.
kubectl describe pods

# Let’s roll back to our previously working version. We’ll use the rollout undo command
# The rollout command reverted the deployment to the previous known state (v2 of the image)
# Updates are versioned and you can revert to any previously know state of a Deployment
kubectl rollout undo deployments/kubernetes-bootcamp

#  List again the Pods
# Four Pods are running
kubectl get pods

# Check again the image deployed on the them
# We see that the deployment is using a stable version of the app (v2). 
# The Rollback was successful.
kubectl describe pods

# Delete the deployment by name
kubectl delete deployment kubernetes-bootcamp

