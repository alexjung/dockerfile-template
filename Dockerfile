#TODO: Change to the desired base image
FROM ubuntu:18.04

MAINTAINER Kowalski <kowalski@penguin.mg>

SHELL ["/bin/bash", "-c"]

# set locales (otherwise python/pip will complain)
RUN apt-get update && \
    apt-get install -y locales && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
ENV LANG en_US.UTF-8

# Some apt packages need the timezone set and will otherwise require a user interaction during the docker build process
ENV TZ=Europe/Berlin
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# install necessary apt packages
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        git ca-certificates \
        build-essential vim \
        cmake zlib1g zlib1g-dev \
        # (optional) python3-dev python3 python3-pip python3-setuptools \
        && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# (optional) install necessary python packages
# RUN pip3 install --upgrade pip
# RUN pip3 install <package-name>

# add local user
# TODO: These are default parameters and
# should be overwritten by the build call
ARG USER=template-user
ARG UID=1000
ARG GID=1000
ARG G_NAME=template-user

RUN useradd -m ${USER} --uid=${UID}

RUN if [ "$USER" != "$G_NAME" ]; then groupadd -g ${GID} ${G_NAME} ; fi
RUN if [ "$USER" != "$G_NAME" ]; then usermod -g ${G_NAME} ${USER} ; fi

USER ${UID}:${GID}
WORKDIR /home/${USER}

ENV HOME /home/${USER}

###########################
### Your code goes here ###
###########################

RUN mkdir /home/${USER}/share
ADD . /home/${USER}/share
WORKDIR /home/${USER}/share
