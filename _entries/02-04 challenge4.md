---
sectionid: deploy
sectionclass: h2
title: Deploying Kubernetes with AKS (30m)
parent-id: upandrunning
---

Azure has a managed Kubernetes service, AKS (Azure Kubernetes Service), you will use this to easily deploy a Kubernetes cluster.

#### Get the latest Kubernetes version available in AKS

You can either let Azure choose the default version of kubernetes for you or you can specify the version during the creation of the cluster. To know which version of kubernetes is supported in your region, use the command `az aks get-versions`

{% collapsible %}

Get the latest available Kubernetes version in your preferred region and store it in a bash variable. Replace `<region>` with the region of your choosing, for example `eastus`.

```sh
version=$(az aks get-versions -l <region> --query 'values[] | [0].version' -o tsv)
```

The command above returns the newest version of Kubernetes available to deploy using AKS. Newer Kubernetes releases are typically made available in “Preview”. To get the latest non-preview version of Kubernetes, use the following command instead.

```sh
version=$(az aks get-versions -l <region> --query 'values[?isPreview == null].[version][0]' -o tsv)
```

{% endcollapsible %}

#### Create the AKS cluster

**Task Hints**

* It's recommended to use the Azure CLI and the `az aks create` command to deploy your cluster. Refer to the docs linked in the Resources section, or run `az aks create -h` for details
* The size and number of nodes in your cluster is not critical, but two or more nodes of type `Standard_DS2_v2` or larger is recommended
* Make sure to enable the [http_application_routing add-on](https://learn.microsoft.com/en-us/azure/aks/http-application-routing) when creating the cluster to simplify networking settings in the next challenges
* You should give the cluster access to the container registry by “attaching” it
* You can optionally create AKS clusters that support the [cluster autoscaler](https://docs.microsoft.com/en-us/azure/aks/cluster-autoscaler#about-the-cluster-autoscaler). We will focus more on this in the advanced sections

Create AKS using the latest version

{% collapsible %}

```sh
az aks create \
  --resource-group <resource-group> \
  --name <unique-aks-cluster-name> \
  --location <region> \
  --kubernetes-version $version \
  --generate-ssh-keys \
  --node-count 2 \
  --generate-ssh-keys \
  --node-vm-size Standard_DS2_v2 \
  --network-plugin azure \
  --enable-addons http_application_routing \
  --attach-acr <registry-name>

az aks nodepool add \
  --resource-group <resource-group> \
  --cluster-name <unique-aks-cluster-name> \
  --name userpool \
  --node-count 2 \
  --node-vm-size Standard_B2s
```

The userpool is used to isolate the pods you will create from the default one managed by the Kubernetes system and you should see something like this:

![Node pools](assets/aks-node-pools.png "Node pools")

> **Notes**

* You can optionally enable the autoscaler using the options `--enable-cluster-autoscaler`, `--min-count`, and `--max-count` in `az aks create`.
* You can attach an ACR registry to an existing AKS cluster using `az aks update -n <cluster-name> -g <resource-group> --attach-acr <registry-name>`

{% endcollapsible %}

#### Ensure you can connect to the cluster using `kubectl`

**Task Hints**

* `kubectl` is the main command line tool you will use for working with Kubernetes and AKS. It is already installed in the Azure Cloud Shell
* Refer to the AKS docs, which includes [a guide for connecting kubectl to your cluster](https://docs.microsoft.com/en-us/azure/aks/kubernetes-walkthrough#connect-to-the-cluster) (Note: if you are using the Azure Cloud Shell you can skip the `install-cli` step because `kubectl` is already installed).
* A good sanity check is listing all the nodes in your cluster `kubectl get nodes`.
* [This is a good cheat sheet](https://kubernetes.io/docs/reference/kubectl/cheatsheet/) for kubectl.

{% collapsible %}

Authenticate against the cluster. The `az aks get-credentials` connect to the cluster and create a local kubeconfig file which will be used by `kubectl` to connect to the cluster.

```sh
az aks get-credentials --resource-group <resource-group> --name <unique-aks-cluster-name>
```

List of the available nodes

```sh
kubectl get nodes
```

> **Notes**
>
> If `kubectl` has some issues to connect to your cluster, you can run the command:
> `export KUBECONFIG=PATH_TO_KUBERNETES_CONFIG_FILE` to specify the path to the credentials generated from the previous `az aks get-credentials` command

{% endcollapsible %}

> **Resources**
>
> * <https://docs.microsoft.com/en-us/azure/aks/kubernetes-walkthrough>
> * <https://learn.microsoft.com/en-us/azure/aks/cluster-container-registry-integration?tabs=azure-cli>
> * <https://docs.microsoft.com/en-us/cli/azure/aks?view=azure-cli-latest#az-aks-create>
> * <https://docs.microsoft.com/en-us/azure/aks/kubernetes-walkthrough-portal>
> * <https://docs.microsoft.com/en-us/azure/aks/kubernetes-walkthrough#connect-to-the-cluster>
> * <https://kubernetes.io/docs/reference/kubectl/cheatsheet/>
