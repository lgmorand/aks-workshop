---
sectionid: runcontainer
sectionclass: h2
title: Running the application within a Docker container (25m)
parent-id: upandrunning
---

In this challenge, you will add a Dockerfile to a web application, build it, and run it using a Docker container. You must understand how to build container images  before using an orchestrator such as Kubernetes.

### Tasks

#### Get the `webapp` source code

Clone the `webapp` from the Github repository [https://github.com/ikhemissi/hello-worlds](https://github.com/ikhemissi/hello-worlds).

The folders are named after various programming languages, so you can choose the one you are most comfortable with.

{% collapsible %}

```sh
# Clone the repo
git clone git@github.com:ikhemissi/hello-worlds.git
cd hello-worlds

# Choose the NodeJS version of the app
cd nodejs
```

{% endcollapsible %}

#### Build a Docker image

To run the app in Docker, you need to add a [Dockerfile](https://docs.docker.com/build/building/packaging/#dockerfile) describing how the app will be built and ran.

Create a new file named `Dockerfile` at the root of the app code and fill it with instructions on how to build and run the app.

> **Hint** Refer to Docker's [language-specific guide](https://docs.docker.com/language/)

{% collapsible %}

```dockerfile
FROM node:lts

ENV NODE_ENV=production

# Copy app code and install dependencies
WORKDIR /app
COPY ["package.json", "package-lock.json*", "./"]
RUN npm install --production
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

#### Run the app

Use `docker run` to start a new container from the image you have just created.

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
