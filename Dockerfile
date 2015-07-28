FROM webhippie/alpine:latest

ENV SSH_USERNAME root
ENV SSH_PASSWORD password

ENV GUI_USERNAME ncsaadmin
ENV GUI_PASSWORD youaintready

# install syncthing
RUN apk update && apk add bash syncthing openssh
USER root

#install openssh
RUN rc-update add sshd
RUN echo "${SSH_USERNAME}:${SSH_PASSWORD}" | chpasswd
RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -i 's/PermitRootLogin no/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -i '#s/PermitRootLogin yes/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN mkdir /root/.ssh && chmod 700 /root/.ssh

VOLUME /root/Sync
EXPOSE 8384 22000 22 21025/udp
ENTRYPOINT syncthing -gui-address=0.0.0.0:8384 -gui-authentication=${GUI_USERNAME}:${GUI_PASSWORD}
