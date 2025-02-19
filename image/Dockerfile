FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

ARG HOSTUSER
ARG HOSTUID
ARG HOSTGID

RUN groupadd -g ${HOSTGID} ${HOSTUSER}
RUN useradd ${HOSTUSER} -u ${HOSTUID} -g ${HOSTGID} -m
RUN echo "${HOSTUSER}:pass" | chpasswd

RUN apt-get update -y
RUN apt-get install -y iputils-ping init wget curl git sudo vim
RUN usermod -aG sudo ${HOSTUSER}
RUN echo "${HOSTUSER} ALL=(ALL)  ALL" >> /etc/sudoers

# Linux Kernel Env 
RUN apt install build-essential flex bison libssl-dev libelf-dev libncurses-dev -y

WORKDIR /home/${HOSTUSER}
USER ${HOSTUSER}
RUN wget https://www.kernel.org/pub/linux/kernel/v5.x/linux-5.0.1.tar.gz
RUN tar zxvf linux-5.0.1.tar.gz && \
    rm linux-5.0.1.tar.gz

CMD ["/sbin/init"]
