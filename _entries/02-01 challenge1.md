---
sectionid: runcontainer
sectionclass: h2
title: Running the application within a Docker container (25m)
parent-id: upandrunning
---

In this challenge, you will add a Dockerfile to a web application, build it, and run it using a Docker container. You must understand how to build container images before using an orchestrator such as Kubernetes. The build of the image must be done on your computer and Docker must be installed and running.

#### Get the `webapp` source code

Download the `webapp` from the Github repository: [hello-worlds.zip](https://github.com/lgmorand/aks-workshop/raw/main/sample-app/hello-worlds.zip)

{% collapsible %}

```sh
wget -O hello-worlds.zip https://github.com/lgmorand/aks-workshop/raw/main/sample-app/hello-worlds.zip
unzip hello-worlds.zip
cd hello-worlds
cd nodejs
```

{% endcollapsible %}

#### Build a Docker image

To run the app in Docker, you need to add a [Dockerfile](https://docs.docker.com/build/building/packaging/#dockerfile) describing how the app will be built and run.

Create a new file named `Dockerfile` at the root of the app code and fill it with instructions on how to build and run the app.

> **Hint** Refer to Docker's [language-specific guide](https://docs.docker.com/language/)

{% collapsible %}

```dockerfile
FROM node:lts

ENV NODE_ENV=production

# Copy app code and install dependencies
WORKDIR /app
COPY ["package.json", "package-lock.json*", "./"]
RUN npm ci
COPY . .

# Start the app
EXPOSE 80
CMD [ "node", "server.js" ]
```

{% endcollapsible %}

Now that you have a Dockerfile, you need to use it to build a Docker image.

Use `docker build` to create the image.

{% collapsible %}

```sh
# Run this command in the root of the nodejs directory, where you created a Dockerfile
docker build -t webapp .
```

{% endcollapsible %}

> Warning: if you get an error message telling that you can't connect to the docker daemon. either start Docker app locally (start Menu) or start your shell with elevated privileges (administrator). "Cannot connect to the Docker daemon at unix:///var/run/docker.sock. Is the docker daemon running?

#### Run the app

Use `docker run` to start a new container from the image you have just created. Use the port 9000 for your test (or any available one).

{% collapsible %}

```sh
# Use the port 9000 to serve the app
docker run -it -p 9000:80 webapp
```

{% endcollapsible %}

Finally, load the app URL [http://localhost:9000](http://localhost:9000) in a browser and make sure you see a `Hello world` message.

> **Resources**
>
> * <https://docs.docker.com/get-started/02_our_app/>
> * <https://docs.docker.com/language/>
> * <https://docs.docker.com/engine/reference/builder/>
