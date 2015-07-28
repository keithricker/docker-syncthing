FROM alpine:3.1

ENV SSH_USERNAME root
ENV SSH_PASSWORD password

ENV GUI_USERNAME ncsaadmin
ENV GUI_PASSWORD youaintready

# install syncthing
RUN apk update && apk add bash syncthing
USER root

#install openssh
RUN apk add -U openssh && rc-update add sshd;
RUN echo "${SSH_USERNAME}:${SSH_PASSWORD}" | chpasswd
RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config

VOLUME /root/Sync
EXPOSE 8384 22000 22 21025/udp
ENTRYPOINT syncthing -gui-address=0.0.0.0:8384 -gui-authentication=${GUI_USERNAME}:${GUI_PASSWORD} & /etc/init.d/sshd start
