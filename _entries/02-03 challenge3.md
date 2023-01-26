---
sectionid: publishingtoacr
sectionclass: h2
title: Publishing to a Docker registry
parent-id: upandrunning
---

Azure provides [ACR](https://learn.microsoft.com/en-us/azure/container-registry/) (Azure Container Registry), a service to host container images.

We will use ACR to store and distribute the container image that we have built in the previous challenges.

### Tasks

#### Create a Resource Group

> **Note** You don't need to create a resource group if you're using the lab environment. You can use the resource group created for you as part of the lab. To retrieve the resource group name in the managed lab environment, run `az group list`.

Create a resource group which will be used to create the registry and the kubernetes cluster (in the next challenge).

{% collapsible %}

Use `az account list-locations` to get a location:

```sh
az account list-locations -o table
```

Then create the resource group using the selected location:

```sh
az group create --name <resource-group> --location <region>
```

{% endcollapsible %}


#### Create a Container Registry

Create a container registry in the new resource group and note down its name.

> **Hint** Check the `Quick start` in the navigation menu of your Container Registry.

{% collapsible %}

```sh
# Create the registry
az acr create --resource-group <resource-group> --name <registry-name> --sku Basic

# List available registries
az acr list --resource-group <resource-group> --output table
```

{% endcollapsible %}


#### Publish the app image

Publish the webapp image to the new registry.

{% collapsible %}

```sh
# Login to the docker registry
docker login <registry-name>

# Tag the existing image with a new registry tag
docker tag webapp <registry-name>/webapp

# Publish the image
docker push <registry-name>/webapp
```

{% endcollapsible %}

Ensure you can pull the image that you have published in the new registry.


{% collapsible %}

```sh
# Pull the image
docker pull <registry-name>/webapp
```

{% endcollapsible %}


> **Resources**
> * <https://learn.microsoft.com/en-us/azure/container-registry/>
> * <https://learn.microsoft.com/en-us/azure/container-registry/container-registry-get-started-docker-cli?tabs=azure-cli/>
