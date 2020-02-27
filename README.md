# Dockerfile Template

This project provides a basic `Dockerfile` and instructions for building and running it. Feel free to suggest improvements or fork it for your own Dockercontainter.

## Security
**Please make sure to always use the latest version of Docker as critical bugs are reported and fixed regularly!**

## Build Image
Execute this in the directory where the `Dockerfile` is located to build the image with your user (id and group) to be used as user in the container (this should prevent issues when accessing files in the shared directory):
```bash
export UID=$(id -u)
export GID=$(id -g)
export G_NAME=$(groups | cut -d' ' -f1)

docker build --build-arg USER=$USER --build-arg UID=$UID --build-arg GID=$GID --build-arg G_NAME=$G_NAME --tag=template .
```
In case you don't want to use your host user-name and group you have to adapt the `build-arg`'s accordingly. The default user and group `template-user` will be used when using the following minmal command:
```bash
docker build --tag=template .
```

## Run Container
This will start the container's bash in interactive mode and mount a shared directory.  
Note that executing `docker run` multiple times will create multiple containers. If you changed your `Dockerfile` and executed `docker build` in between `docker run` executions you can end up with multiple versions of your container. User the option `--name` to give meaningful names to your containers.

*Change paths accordingly! This command assumes that you also use your host user-name inside the container!*
```bash
docker run -it -v PATH_TO_HOST_SHARE:/home/${USER}/share --name template-name template:latest /bin/bash
```
If you did not specify any user or name via the `build-arg`'s use the following command assuming the default user inside the container:
```bash
docker run -it -v PATH_TO_HOST_SHARE:/home/template-user/share --name template-name template:latest /bin/bash
```

Additionally the option `--name` makes it easier to identify the container later on (e.g. when listing all containers with `docker ps -a`).  
Moreover you will get an error message when you try to execute `docker run` multiple times with the same name. You have to remove the container first to reuse a name (`docker rm template-name`).

You can exit the container with <kbd>CTRL</kbd>+<kbd>D</kbd> and restart it with the command:
```bash
docker start -ia template-name
```
