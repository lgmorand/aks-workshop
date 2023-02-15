---
sectionid: containerconfig
sectionclass: h2
title: Customizing the containerized app (5m)
parent-id: upandrunning
---

In this challenge, you will customize the behaviour of the webapp container using environment variables without having to re-create the Docker image.

### Tasks

#### Customize the app with environment variables

Customize the output of the app without rebuilding the Docker image to have the following changes:

- return `hello Docker` instead of `hello world`
- set the header `X-Version` to `1.0.0`
- set the header `X-Environment` to `test`

{% collapsible %}

```sh
docker run -it -p 9000:80 -e "GREETEE=Docker" -e "VERSION=1.0.0" -e "ENVIRONMENT=test" webapp
```

{% endcollapsible %}

> **Note** While you can customize the behaviour of containers using arguments (build), environment variables (runtime), volumes (runtime), and network calls (runtime), the deployment envrironment is usually set with an environment variable and the app version is usually set using an argument.

> **Resources**
>
> - <https://docs.docker.com/engine/reference/run/>
