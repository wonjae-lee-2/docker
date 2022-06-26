# syntax=docker/dockerfile:1

ARG UBUNTU_VERSION

FROM ubuntu:${UBUNTU_VERSION}

RUN apt update; \
    apt install -y \
        sudo \
        wget \
        python3; \
    sed -i "s/%sudo\tALL=(ALL:ALL) ALL/%sudo\tALL=(ALL:ALL) NOPASSWD:ALL/g" /etc/sudoers; \
    useradd -m ubuntu; \
    usermod -aG sudo ubuntu

WORKDIR /home/ubuntu

USER ubuntu

RUN mkdir ~/downloads ~/venv

CMD [ "bash" ]
