---
sectionid: prereq
sectionclass: h2
title: Prerequisites
parent-id: intro
---

### Tools

This course is entirely explained from a Linux environment (on Windows, a quick win can be to [go with the Windows Linux Subsystem](https://learn.microsoft.com/en-us/windows/wsl/install) or [Git BASH](https://gitforwindows.org)).

You can use [the Azure Cloud Shell service](https://shell.azure.com) once you log in with an Azure subscription. The Azure Cloud Shell has the Azure CLI pre-installed and configured to connect to your Azure subscription, as well as [kubectl](https://github.com/kubernetes/kubectl) and [Helm](https://github.com/helm/helm).

Alternatively, you need to meet the following requirements:

- [Azure CLI](https://github.com/Azure/azure-cli) v2.53.0
- [Docker CLI](https://github.com/docker/cli) v24.0.1, with [Docker Desktop](https://www.docker.com/products/docker-desktop), or, for licensing-related issues, use [Podman](https://github.com/containers/podman) and [Podman Desktop](https://github.com/containers/podman-desktop)
- [Helm](https://github.com/helm/helm) v3.11.1
- [kubectl](https://github.com/kubernetes/kubectl) v0.26.X
- [Kubernetes](https://kubernetes.io) v1.26 (managed from [Azure Kubernetes Service](https://learn.microsoft.com/en-us/azure/aks))

### Azure subscription

#### If you have an Azure subscription

{% collapsible %}

Please consider using your username and password to login into [the Azure Portal](https://portal.azure.com). Also, please authenticate your Azure CLI by running the command below on your machine and following the instructions.

```sh
az account show
az login
```

{% endcollapsible %}

#### Azure Cloud Shell

You can use the Azure Cloud Shell accessible at <https://shell.azure.com> once you log in with an Azure subscription.

{% collapsible %}

Head over to <https://shell.azure.com> and sign in with your Azure Subscription details.

Select **Bash** as your shell.

![Select Bash](./media/cloudshell/0-bash.png)

Select **Show advanced settings**

![Select Show advanced settings](./media/cloudshell/1-mountstorage-advanced.png)

Set the **Storage account** and **File share** names to your resource group name (all lowercase, without any special characters), then hit **Create storage**

![Azure Cloud Shell](./media/cloudshell/2-storageaccount-fileshare.png)

You should now have access to the Azure Cloud Shell

![Set the storage account and fileshare names](./media/cloudshell/3-cloudshell.png)

{% endcollapsible %}

#### Tips for uploading and editing files in Azure Cloud Shell

- You can use `code <file you want to edit>` in Azure Cloud Shell to open the built-in text editor.
- You can upload files to the Azure Cloud Shell by dragging and dropping them
- You can also do a `curl -o filename.ext https://file-url/filename.ext` to download a file from the internet.
