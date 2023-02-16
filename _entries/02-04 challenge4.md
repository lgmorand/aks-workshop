---
sectionid: deploy
sectionclass: h2
title: Deploying Kubernetes with AKS (30m)
parent-id: upandrunning
---

Azure has a managed Kubernetes service, AKS (Azure Kubernetes Service), you will use this to easily deploy a Kubernetes cluster.

### Tasks

#### Get the latest Kubernetes version available in AKS

{% collapsible %}

Get the latest available Kubernetes version in your preferred region and store it in a bash variable. Replace `<region>` with the region of your choosing, for example `eastus`.

```sh
version=$(az aks get-versions -l <region> --query 'orchestrators[?!isPreview] | [-1].orchestratorVersion' -o tsv)
```

The command above returns the newest version of Kubernetes available to deploy using AKS. Newer Kubernetes releases are typically made available in “Preview”. To get the latest non-preview version of Kubernetes, use the following command instead.

```sh
version=$(az aks get-versions -l <region> --query 'orchestrators[?isPreview == null].[orchestratorVersion][-1]' -o tsv)
```

{% endcollapsible %}

#### Create the AKS cluster

**Task Hints**

* It's recommended to use the Azure CLI and the `az aks create` command to deploy your cluster. Refer to the docs linked in the Resources section, or run `az aks create -h` for details
* The size and number of nodes in your cluster is not critical, but two or more nodes of type `Standard_DS2_v2` or larger is recommended
* Make sure to enable the [http_application_routing add-on](https://learn.microsoft.com/en-us/azure/aks/http-application-routing) when creating the cluster to simplify networking settings in the next challenges
* You should give the cluster access to the container registry by “attaching” it
* You can optionally create AKS clusters that support the [cluster autoscaler](https://docs.microsoft.com/en-us/azure/aks/cluster-autoscaler#about-the-cluster-autoscaler). We will focus more on this in the advanced sections

Create AKS using the latest version (if using the provided lab environment)

{% collapsible %}

> **Note** If you're using the provided lab environment, you'll not be able to create the Log Analytics workspace required to enable monitoring while creating the cluster from the Azure Portal unless you manually create the workspace in your assigned resource group. Additionally, if you're running this on an Azure Pass, please add `--load-balancer-sku basic` to the flags, as the Azure Pass only supports the basic Azure Load Balancer. Additionaly, please pass in the service prinipal and secret provided.

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

> **Notes**

* You can optionally enable the autoscaler using the options `--enable-cluster-autoscaler`, `--min-count`, and `--max-count` in `az aks create`.
* You can attach an ACR registry to an existing AKS cluster using `az aks update -n <cluster-name> -g <resource-group> --attach-acr <registry-name>`

{% endcollapsible %}

#### Ensure you can connect to the cluster using `kubectl`

**Task Hints**

* `kubectl` is the main command line tool you will use for working with Kubernetes and AKS. It is already installed in the Azure Cloud Shell
* Refer to the AKS docs, which includes [a guide for connecting kubectl to your cluster](https://docs.microsoft.com/en-us/azure/aks/kubernetes-walkthrough#connect-to-the-cluster) (Note, using the cloud shell you can skip the `install-cli` step).
* A good sanity check is listing all the nodes in your cluster `kubectl get nodes`.
* [This is a good cheat sheet](https://kubernetes.io/docs/reference/kubectl/cheatsheet/) for kubectl.

{% collapsible %}

> **Note** `kubectl`, the Kubernetes CLI, is already installed on the Azure Cloud Shell.

Authenticate

```sh
az aks get-credentials --resource-group <resource-group> --name <unique-aks-cluster-name>
```

List of the available nodes

```sh
kubectl get nodes
```

{% endcollapsible %}

> **Resources**
>
> * <https://docs.microsoft.com/en-us/azure/aks/kubernetes-walkthrough>
> * <https://learn.microsoft.com/en-us/azure/aks/cluster-container-registry-integration?tabs=azure-cli>
> * <https://docs.microsoft.com/en-us/cli/azure/aks?view=azure-cli-latest#az-aks-create>
> * <https://docs.microsoft.com/en-us/azure/aks/kubernetes-walkthrough-portal>
> * <https://docs.microsoft.com/en-us/azure/aks/kubernetes-walkthrough#connect-to-the-cluster>
> * <https://kubernetes.io/docs/reference/kubectl/cheatsheet/>
