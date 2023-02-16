---
sectionid: basicmonitoring
sectionclass: h2
title: Getting basic activity metrics (15m)
parent-id: upandrunning
---

Congratulations! You have deployed your `webapp` in an AKS cluster and you made it publicly accessible. In this challenge, you will explore the native integration between AKS and [Azure Monitor](https://learn.microsoft.com/en-us/azure/azure-monitor/overview) by checking basic metrics about the cluster.

### Tasks

#### Get cluster activity metrics

Head to the [Azure portal](https://portal.azure.com/), and click on the `Metrics` menu option under `Monitoring` on the left panel.

Answer the following questions:

- What is the average CPU usage?
- How much RAM is allocated?
- How much disk space is used?
- How much inbound traffic?
- How much outbound traffic?
- What is the total amount of available memory in the cluster?

{% collapsible %}

Check the following metrics:

| Metric            | Metric name                                           |
|-------------------|-------------------------------------------------------|
| Average CPU usage | CPU Usage Percentage                                  |
| RAM allocation    | Memory RSS Percentage                                 |
| Disk space usage  | Disk Used Percentage                                  |
| Inbound traffic   | Network In Bytes                                      |
| Outbound traffic  | Network Out Bytes                                     |
| Available memory  | Total amount of available memory in a managed cluster |

{% endcollapsible %}

> **Note** Configure [Container Insights](https://learn.microsoft.com/en-us/azure/aks/monitor-aks#container-insights) to expand on the basic monitoring features and get data about the health and performance of your AKS cluster.

> **Resources**
>
> - <https://learn.microsoft.com/en-us/azure/aks/monitor-aks/>
