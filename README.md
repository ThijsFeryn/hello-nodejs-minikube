#Hello NodeJS example for Kubernetes
This repository contains a *Hello NodeJS* sample application that contains the necessary configuration files to be run on a [Kubernetes](https://kubernetes.io) cluster.

##Why?
On June 27th 2017 I attended [a meetup organized by the Belgian Docker meetup group in Gent](https://www.meetup.com/Docker-Belgium/events/240475061/). The event was actually a Kubernetes workshop by [Benjamin Henrion](https://twitter.com/zoobab).

I attended the workshop and created [a blog post](https://blog.feryn.eu/kubernetes-workshop/) and a [vlog episode](https://www.youtube.com/watch?v=y4tbQCFj7Ps) about it.

This repository actually contains a sample application that is used in the vlog. It's an extract from Benjamin's workshop. The course material for the workshop can be found [on Benjamin's website](http://www.zoobab.com/kubernetes-workshop)

##The code

The end goal is to run the NodeJS script below:

```var http = require('http');
var handleRequest = function(request, response){
    console.log("rx request for url:" + request.url);
    response.writeHead(200)
    response.end('Hello World: ' +  process.env.HOSTNAME);
};

var www = http.createServer(handleRequest);
www.listen(8080);
```

It starts a basic webserver and prints `Hello World:`, followed by the value of the `HOSTNAME` environment variable. You could run this on your local computer. You can start the server as follows:

```
HOSTNAME=`hostname` node server.js
```

You can call the application by issuing a curl call:

```
curl localhost:8080
```

##What about Docker?

You can deploy the [server.js](server.js) script to any machine you want, but nowadays running the application in a *Docker* container is very popular.

The [Dockerfile](Dockerfile) contains the necessary instructions to turn this simple application into a *Docker image*. Just run the following command to build the image:

```
docker build -t hello-nodejs .
```

Eventually you could use `docker run` to run the application, but we'll let Kubernetes handle this.

##What about Kubernetes?

Running a Docker container ain't that hard, but running it on a cluster of nodes brings some interesting challenges to the table:

* Replication
* High availability
* Loadbalancing
* Storage
* Networking
* ...

Kubernetes takes care of that and a lot more. To keep it simple, I'll just show you how to create a *deployment* and a *service*. 

If all of this sounds confusing, go to [the Kubernetes website and read the part that explains the core concepts](https://kubernetes.io/docs/concepts/).

###The deployment
A deployment contains information about the Docker image that will be deployed and what parameters that will be used. The end result is one or more [pods](https://kubernetes.io/docs/concepts/workloads/pods/pod-overview/) that will be scheduled on the Kubernetes cluster.

The [hello\_nodejs\_deployment.yml](hello_nodejs_deployment.yml) configuration file contains all this information and is run as follows:

```
kubectl create -f hello_nodejs_deployment.yml
```

###The service

In order to expose these containers to the outside world, we can use [services](https://kubernetes.io/docs/concepts/services-networking/service/). They our bound to a deployment and expose an endpoint.


The [hello\_nodejs\_service.yml](hello_nodejs_service.yml) configuration file contains all this information and is run as follows:

```
kubectl create -f hello_nodejs_service.yml
```

##What about Minikube?
Running Kubernetes in production will require at least 3 nodes. Installing all the required software and configuring all the settings is quite a task.

If you just want to run Kubernetes on your local computer without the hassle, there's a project called [Minikube](https://github.com/kubernetes/minikube). Minikube runs Kubernetes within a virtual machine. 

If you've installed Minikube, you can just run `minikube start` to get going. If you want your docker binary to point to the Docker installation running within Kubernetes, you can just run `eval $(minikube docker-env)`.

Once you've deployed your services, it's not possible to call the endpoints directly, because Minikube runs Kubernetes in the virtual machine. Luckily Minikube can translate those by running the following command:

```
minikube service hello-nodejs-service --url
```

This endpoint can then be run via curl:

```
curl $(minikube service hello-nodejs-service --url)
```
