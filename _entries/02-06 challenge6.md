---
sectionid: enablingpublicaccess
sectionclass: h2
title: Enabling public access (30m)
parent-id: upandrunning
---

Now that you have deployed the application to AKS, it is time to expose it to the internet to allow clients to use it.
By default, Kubernetes blocks all external traffic, so you will need to add an *ingress rule* to allow traffic into the cluster.

In this challenge, you will expose the application by creating a [Service](https://kubernetes.io/docs/concepts/services-networking/service/) and an [Ingress](https://kubernetes.io/docs/concepts/services-networking/ingress/).

### Tasks

#### Create a Service

Create and deploy a Service manifest file and set its type to `ClusterIP`.

{% collapsible %}

Create a `service.yaml` file with the following contents:

```yaml
#service.yaml
apiVersion: v1
kind: Service
metadata:
  name: webapp
spec:
  type: ClusterIP
  selector:
    app: webapp
  ports:
    - port: 80 # SERVICE exposed port
      name: http # SERVICE port name
      protocol: TCP # The protocol the SERVICE will listen to
      targetPort: http # Port to forward to in the POD
```

Then deploy it using the following command:

```sh
kubectl apply -f ./service.yaml
```

You should see an output like:

```sh
service/webapp created
```

{% endcollapsible %}

Make sure the service was created using `kubectl get service`

{% collapsible %}

Run the following command:

```sh
kubectl get service webapp
```

You should see an output like:

```sh
NAME     TYPE        CLUSTER-IP    EXTERNAL-IP   PORT(S)   AGE
webapp   ClusterIP   10.0.17.161   <none>        80/TCP    2m9s
```

{% endcollapsible %}

#### Create an Ingress

Create and deploy an Ingress manifest file to make the app publicly accessible.

**Task Hints**

* You can use the DNS zone created by enabling [http_application_routing add-on](https://learn.microsoft.com/en-us/azure/aks/http-application-routing) when you created the cluster. You can use [az aks show](https://learn.microsoft.com/en-us/azure/aks/http-application-routing#deploy-http-routing-cli) to get the DNS zone.

{% collapsible %}

Create an `ingress.yaml` file with the following contents:

```yaml
#ingress.yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: webapp
  annotations:
    kubernetes.io/ingress.class: addon-http-application-routing
spec:
  rules:
    - host: <dns-zone-name>
      http:
        paths:
          - backend: # How the ingress will handle the requests
              service:
               name: webapp # Which service the request will be forwarded to
               port:
                 name: http # Which port in that service
            path: / # Which path is this rule referring to
            pathType: Prefix # See more at https://kubernetes.io/docs/concepts/services-networking/ingress/#path-types
```

Then deploy it using the following command:

```sh
kubectl apply -f ./ingress.yaml
```

You should see an output like:

```sh
ingress.networking.k8s.io/webapp created
```

{% endcollapsible %}

#### Test the app

Make a request to the webapp using the FQDN of the newly created ingress and ensure it returns `Hello AKS`.

{% collapsible %}

Use `kubectl get ingress` to get the FQDN of the ingress and ensure there is a public IP:

```sh
kubectl get ingress webapp
```

You should see an output similar to:

```sh
NAME     CLASS    HOSTS                                       ADDRESS        PORTS   AGE
webapp   <none>   0c29284998e94bea9005.westeurope.aksapp.io   20.23.222.68   80      52s
```

You can now load the url `0c29284998e94bea9005.westeurope.aksapp.io` on your browser and ensure it returns `Hello AKS`.

{% endcollapsible %}

> **Resources**
>
> * <https://kubernetes.io/docs/concepts/services-networking/>
> * <https://learn.microsoft.com/en-us/cli/azure/network/dns/zone?view=azure-cli-latest#az-network-dns-zone-list/>
> * <https://learn.microsoft.com/en-us/azure/aks/http-application-routing/>
> * <https://learn.microsoft.com/en-us/training/modules/aks-deploy-container-app/7-exercise-expose-app/>
