---
sectionid: prereq
sectionclass: h2
title: Prerequisites
parent-id: intro
---

### Tools

This course is entirely explained from a Linux environment (on Windows, quick win can be to [go with the Windows Linux Subsystem](https://learn.microsoft.com/en-us/windows/wsl/install) or [Git BASH](https://gitforwindows.org)).

Alternatively, you need to ensure you have an updated version of Docker installed on your computer. You can install it using [Docker Desktop](https://www.docker.com/products/docker-desktop/).

### Azure subscription

#### If you have an Azure subscription

{% collapsible %}

Please consider using your username and password to login in to [the Azure Portal](https://portal.azure.com). Also, please authenticate your Azure CLI by running the command below on your machine and following the instructions.

```sh
az account show
az login
```

{% endcollapsible %}

#### If you have been given access to a subscription as part of a lab, or you already have a Service Principal you want to use

{% collapsible %}
If you have lab environment credentials similar to the below, or you already have a Service Principal you will use with this workshop,

![Lab environment credentials](media/lab-env.png)

Please then perform an `az login` on your machine using the command below, passing in the `Application Id`, the `Application Secret Key` and the `Tenant Id`.

```sh
az login --service-principal --username APP_ID --password "APP_SECRET" --tenant TENANT_ID
```

{% endcollapsible %}

#### Azure Cloud Shell

You can use the Azure Cloud Shell accessible at <https://shell.azure.com> once you log in with an Azure subscription.

{% collapsible %}

Head over to <https://shell.azure.com> and sign in with your Azure Subscription details.

Select **Bash** as your shell.

![Select Bash](media/cloudshell/0-bash.png)

Select **Show advanced settings**

![Select show advanced settings](media/cloudshell/1-mountstorage-advanced.png)

Set the **Storage account** and **File share** names to your resource group name (all lowercase, without any special characters), then hit **Create storage**

![Azure Cloud Shell](media/cloudshell/2-storageaccount-fileshare.png)

You should now have access to the Azure Cloud Shell

![Set the storage account and fileshare names](media/cloudshell/3-cloudshell.png)

{% endcollapsible %}

#### Tips for uploading and editing files in Azure Cloud Shell

- You can use `code <file you want to edit>` in Azure Cloud Shell to open the built-in text editor.
- You can upload files to the Azure Cloud Shell by dragging and dropping them
- You can also do a `curl -o filename.ext https://file-url/filename.ext` to download a file from the internet.
