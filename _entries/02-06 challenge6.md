---
sectionid: enablingpublicaccess
sectionclass: h2
title: Enabling public access (30m)
parent-id: upandrunning
---

Now that you have deployed the application to AKS, it is time to expose it to the internet to allow clients to use it.
By default, Kubernetes blocks all external traffic, so you will need to add an *ingress rule* to allow traffic into the cluster.

In this challenge, you will expose the application by creating a [Service](https://kubernetes.io/docs/concepts/services-networking/service/) and an [Ingress](https://kubernetes.io/docs/concepts/services-networking/ingress/).

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

You should see an output like this:

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

You should see an output such as:

```sh
NAME     TYPE        CLUSTER-IP    EXTERNAL-IP   PORT(S)   AGE
webapp   ClusterIP   10.0.17.161   <none>        80/TCP    2m9s
```

From now and only **from inside the cluster**, you can access your Web Application either with http://webapp or with http://IP-GIVEN-TO-SERVICE.
Let's continue to make your application accessible from Internet.

{% endcollapsible %}

#### Create an Ingress

Create and deploy an [Ingress manifest](https://kubernetes.io/docs/concepts/services-networking/ingress/) file to make the app publicly accessible. You will have to define the `host` property.

**Task Hints**

* You can use the DNS zone created by enabling [http_application_routing add-on](https://learn.microsoft.com/en-us/azure/aks/http-application-routing) when you created the cluster. You can use [az aks show](https://learn.microsoft.com/en-us/azure/aks/http-application-routing#deploy-http-routing-cli) to get the host name.

{% collapsible %}

First, get the host name by running this command:

```sh
az aks show --resource-group <resource-group-name> --name <cluster-name> --query addonProfiles
```

You will get a JSON result with this section:

```json
"addonProfiles": {
    "httpApplicationRouting": {
      "config": {
        "HTTPApplicationRoutingZoneName": "3f6f8a980e453ba5e9.francecentral.aksapp.io"
      },
    }
}
```

The host name to use is inside the property `HTTPApplicationRoutingZoneName`.

Create an `ingress.yaml` file with the following content:

```yaml
# ingress.yaml
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

> **Note**
>
> The annotation `kubernetes.io/ingress.class: addon-http-application-routing` is deprecated and will be replaced by `ingressClassName: addon-http-application-routing` in the `spec` section. This will be managed in future version of AKS.

Then deploy it using the following command:

```sh
kubectl apply -f ./ingress.yaml
```

You should see an output like this:

```sh
ingress.networking.k8s.io/webapp created
```

{% endcollapsible %}

#### Test the app

Make a request to the web app using the FQDN of the newly created ingress and ensure it returns `Hello AKS`.

> Note: it may takes few minutes for the full FQDN to work

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

You can now load the URL `0c29284998e94bea9005.westeurope.aksapp.io` on your browser and ensure it returns `Hello AKS`.

{% endcollapsible %}

> **Resources**
>
> * <https://kubernetes.io/docs/concepts/services-networking/>
> * <https://learn.microsoft.com/en-us/cli/azure/network/dns/zone?view=azure-cli-latest#az-network-dns-zone-list/>
> * <https://learn.microsoft.com/en-us/azure/aks/http-application-routing/>
> * <https://learn.microsoft.com/en-us/training/modules/aks-deploy-container-app/7-exercise-expose-app/>
