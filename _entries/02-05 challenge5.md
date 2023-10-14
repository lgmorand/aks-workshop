---
sectionid: deployingwebapptoaks
sectionclass: h2
title: Deploying the app to AKS (20m)
parent-id: upandrunning
---

In this challenge, you will deploy the web app that you have built and ran locally into the Kubernetes cluster that you created in the previous challenge.

#### Create a deployment manifest

You need a deployment manifest file to deploy your application. The manifest file allows you to define what type of resource you want to deploy and all the details associated with the workload.

Kubernetes groups containers into logical structures called pods, which have no intelligence. Deployments add the missing intelligence to create your application.

Create a deployment file and set the environment variable `GREETEE` to `AKS`.

{% collapsible %}

Create a `deployment.yaml` file with the following contents, and make sure to replace `<registry-fqdn>` with the fully qualified name of your registry:

```yaml
# deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: webapp
spec:
  selector: # Define the wrapping strategy
    matchLabels: # Match all pods with the defined labels
      app: webapp # Labels follow the `name: value` template
  template: # This is the template of the pod inside the deployment
    metadata:
      labels:
        app: webapp
    spec:
      nodeSelector:
        kubernetes.io/os: linux
      containers:
        - image: <registry-fqdn>/webapp # Registry created in challenge 3
          name: webapp
          resources:
            requests:
              cpu: 100m
              memory: 128Mi
            limits:
              cpu: 250m
              memory: 256Mi
          ports:
            - containerPort: 80
              name: http
          env:
            - name: GREETEE
              value: AKS
```

{% endcollapsible %}

#### Deploy the web app image using the manifest

Use `kubectl` to apply the manifest and deploy the app.

{% collapsible %}

Apply the deployment:

```sh
kubectl apply -f ./deployment.yaml
```

Then ensure it was successful:

```sh
kubectl get deploy webapp
```

You should see an output similar to:

```sh
NAME              READY   UP-TO-DATE   AVAILABLE   AGE
webapp            0/1     1            0           16s
```

{% endcollapsible %}

Use `kubectl get pods` to check if the pod is running. Obtain the name of the created pod.

{% collapsible %}

```sh
kubectl get pods
```

You should see an output similar to:

```sh
NAME                               READY   STATUS    RESTARTS   AGE
webapp-7c58c5f699-r79mv            1/1     Running   0          63s
```

{% endcollapsible %}

#### Test the app

Make a request to the newly deployed web app and ensure it returns `Hello AKS`.

**Task Hints**

* Use port forwarding with `kubectl port-forward` to directly access pods in the AKS cluster

{% collapsible %}

Use `kubectl port-forward` to directly access a pod:

```sh
# Replace <pod-name> with the name returned by kubectl get pods
# Replace <local-port> with a port number on your machine, e.g. 4000
# Replace <pod-port> with the port number on which the pod listens for requests, e.g. 80
kubectl port-forward <pod-name> <local-port>:<pod-port>
```

You can now load the URL `http://localhost:4000/` on your browser and ensure it returns `Hello AKS`.

{% endcollapsible %}

> **Resources**
>
> * <https://kubernetes.io/docs/concepts/workloads/controllers/deployment/>
> * <https://kubernetes.io/docs/tasks/access-application-cluster/port-forward-access-application-cluster/>
> * <https://learn.microsoft.com/en-us/training/modules/aks-deploy-container-app/5-exercise-deploy-app/>
> * <https://learn.microsoft.com/en-us/azure/aks/node-access/>
