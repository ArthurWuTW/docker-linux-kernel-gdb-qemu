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
RUN apt install build-essential flex bison libssl-dev libelf-dev libncurses-dev bc -y

# Fix Compile Error
# reference https://zhuanlan.zhihu.com/p/493122508
# error: ‘-mindirect-branch’ and ‘-fcf-protection’ are not compatible
# root cause: gcc version is too high.
RUN apt-get install gcc-8 g++-8 -y
RUN update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-8 100
RUN update-alternatives --config gcc
RUN update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-8 100
RUN update-alternatives --config g++

# Debian rootfs dependencies
RUN apt install cpio debootstrap -y

WORKDIR /home/${HOSTUSER}
USER ${HOSTUSER}
RUN wget https://www.kernel.org/pub/linux/kernel/v5.x/linux-5.0.1.tar.gz
RUN tar zxvf linux-5.0.1.tar.gz && \
    rm linux-5.0.1.tar.gz

RUN cd /home/${HOSTUSER}/linux-5.0.1 && \
    export ARCH=x86_64 && \
    make x86_64_defconfig

# >> make menuconfig -> Save -> .config  
##################################################################
# General setup  --->
#     [*] Initial RAM filesystem and RAM disk (initramfs/initrd) support

# Device Drivers  --->
#     [*] Block devices  --->
#         <*> RAM block device support
#             (65536) Default RAM disk size (kbytes)

# Processor type and features  --->
#     [*] Randomize the address of the kernel image (KASLR)
    
# Kernel hacking  --->
#     Compile-time checks and compiler options  ---> 
#         [*] Compile the kernel with debug info
#             [*] Provide GDB scripts for kernel debugging

# Device Drivers --> 
#     Network device support --> 
#         <*> Universal TUN/TAP device driver support

# [*] Networking support --> 
#         Networking options --> 
#             <*> 802.1d Ethernet Bridging
##################################################################
COPY .config /home/${HOSTUSER}/linux-5.0.1/.config
RUN cd /home/${HOSTUSER}/linux-5.0.1 && \
    make -j4

USER root
RUN cd /home/${HOSTUSER}/linux-5.0.1 && \
    debootstrap --arch=amd64 bookworm debian-rootfs http://deb.debian.org/debian/

RUN mount -f --bind /proc /home/${HOSTUSER}/linux-5.0.1/debian-rootfs/proc
RUN mount -f --bind /dev /home/${HOSTUSER}/linux-5.0.1/debian-rootfs/dev
RUN mount -f --bind /sys /home/${HOSTUSER}/linux-5.0.1/debian-rootfs/sys
RUN mount -f --bind /run /home/${HOSTUSER}/linux-5.0.1/debian-rootfs/run
RUN chroot /home/${HOSTUSER}/linux-5.0.1/debian-rootfs /bin/bash -c 'apt install gcc python3 net-tools build-essential binutils strace -y'

RUN cd /home/${HOSTUSER}/linux-5.0.1 && \
    chown -R ${HOSTUSER}:${HOSTUSER} debian-rootfs

USER ${HOSTUSER}
COPY busybox/init /home/${HOSTUSER}/linux-5.0.1/debian-rootfs/init
COPY socket_server.c /home/${HOSTUSER}/linux-5.0.1/debian-rootfs/socket_server.c
RUN cd /home/${HOSTUSER}/linux-5.0.1/debian-rootfs && \
    find . -print0 | cpio --null -ov --format=newc | gzip -9 > ./initramfs-debian-x86.cpio.gz


CMD ["/sbin/init"]