FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

ARG HOSTUSER
ARG HOSTUID
ARG HOSTGID

RUN groupadd -g ${HOSTGID} ${HOSTUSER}
RUN useradd ${HOSTUSER} -u ${HOSTUID} -g ${HOSTGID} -m

RUN apt-get update -y
RUN apt-get install -y iputils-ping init wget curl git sudo vim

RUN wget https://www.kernel.org/pub/linux/kernel/v5.x/linux-5.0.1.tar.gz -P /home/${HOSTUSER}
RUN cd /home/${HOSTUSER} && tar zxvf linux-5.0.1.tar.gz && rm linux-5.0.1.tar.gz
RUN cd /home/${HOSTUSER} && chown -Rv ${HOSTUSER}:${HOSTUSER} linux-5.0.1

CMD ["/sbin/init"]
