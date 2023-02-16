---
sectionid: autoscaling
sectionclass: h2
title: Handling load spikes (30m)
parent-id: deepdive
---

Enabling autoscaling on your AKS cluster allows you to seamlessly handle increased demand by adding nodes and service instances as needed, based on resource usage.

Doing so will also help reduce operating costs by reducing the number of nodes in the cluster when they are no longer needed, for example after rush hours.

![Cluster and Pod Autoscaler](./media/cluster-autoscaler.png "Cluster and Pod Autoscaler")

In this challenge, we will explore scaling both cluster nodes and the number of service instances (pods in a service).

### Tasks

#### Enable the Horizontal Pod Autoscaler

**Task Hints**

* Make sure you have defined [resource requests and limits](https://learn.microsoft.com/en-us/azure/aks/developer-best-practices-resource-management#define-pod-resource-requests-and-limits) for your pod.

Enable the Horizontal Pod Scaler to automatically scale the number of replicas of `webapp` (from 1 to 3) depending on resource usage (CPU utilization > 50%).

{% collapsible %}

Run the following command to enable autoscaling on the `webapp` deployment:

```sh
kubectl autoscale deployment webapp --cpu-percent=50 --min=1 --max=3
```

Then use `kubectl get hpa` to get the status of the autoscaler.
You should see an output similar to:

```sh
NAME     REFERENCE           TARGETS   MINPODS   MAXPODS   REPLICAS   AGE
webapp   Deployment/webapp   1%/50%    1         3         1          17s
```

Alternatively, you can use manifest files to enable the autoscaler while tracking your changes.

To do so, you can create a `webapp-hpa.yaml` with the following contents and apply it with `kubectl apply`:

```yaml
# webapp-hpa.yaml
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: webapp-hpa
spec:
  maxReplicas: 3 # define max replica count
  minReplicas: 1  # define min replica count
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: webapp
  metrics:
  - type: Resource
    resource:
      name: cpu
      target:
        type: Utilization
        averageUtilization: 50 # target CPU utilization
```

{% endcollapsible %}

#### Test the Horizontal Pod Autoscaler

**Task Hints**

* You can use [Azure Load Testing](https://learn.microsoft.com/en-us/azure/load-testing/quickstart-create-and-run-load-test) to simulate load spikes.

Load test your service and make sure the number of pods scales up and down depending on CPU utilization.

{% collapsible %}

Use the following command to watch changes to the deployment:

```sh
kubectl get hpa --watch
```

Then create a quick test by following the steps in [Azure Load Testing](https://learn.microsoft.com/en-us/azure/load-testing/quickstart-create-and-run-load-test).

As a reminder, you can get the URL of your service using `kubectl get ingress`.

You should start seeing an output that looks like:

```sh
NAME         REFERENCE           TARGETS   MINPODS   MAXPODS   REPLICAS   AGE
webapp-hpa   Deployment/webapp   1%/50%    1         3         1          88m
webapp-hpa   Deployment/webapp   84%/50%   1         3         1          89m
webapp-hpa   Deployment/webapp   84%/50%   1         3         2          90m
webapp-hpa   Deployment/webapp   123%/50%   1         3         2          90m
webapp-hpa   Deployment/webapp   219%/50%   1         3         3          91m
webapp-hpa   Deployment/webapp   146%/50%   1         3         3          92m
webapp-hpa   Deployment/webapp   111%/50%   1         3         3          92m
webapp-hpa   Deployment/webapp   1%/50%     1         3         3          93m
webapp-hpa   Deployment/webapp   1%/50%     1         3         3          97m
webapp-hpa   Deployment/webapp   1%/50%     1         3         1          98m
```

Once the load test ends, you should start seeing changes in resource usage (`TARGETS`) and then the number of `REPLICAS` should start dropping back to `1` (this may take a couple of minutes).

{% endcollapsible %}

#### Enable the Cluster Autoscaler

Update the user node pool (e.g., `userpool`) of your AKS cluster to enable the autoscaler and define the minimum number of nodes to 1 and the maximum to 3.

{% collapsible %}

Run the following command to enable the cluster autoscaler:

```sh
az aks nodepool update \
    --enable-cluster-autoscaler \
    --min-count 1 \
    --max-count 3 \
    -n <user-node-pool> \ # name of the User node pool, e.g. userpool
    -g <resource-group> \
    --cluster-name <aks-cluster-name>
```

This operation may take a few minutes, so meanwhile, you can check the latest state of the node pool using the following command:

```sh
az aks nodepool show \
    -n <user-node-pool> \ # name of the User node pool, e.g. userpool
    -g <resource-group> \
    --cluster-name <aks-cluster-name>
```

{% endcollapsible %}

> **Resources**
>
> * <https://learn.microsoft.com/en-us/azure/aks/concepts-scale/>
> * <https://learn.microsoft.com/en-us/azure/aks/tutorial-kubernetes-scale?tabs=azure-cli#autoscale-pods/>
> * <https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/>
> * <https://kubernetes.io/docs/reference/generated/kubectl/kubectl-commands#autoscale/>
> * <https://learn.microsoft.com/en-us/azure/aks/cluster-autoscaler/>
