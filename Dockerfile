FROM kricker/mysql-base:latest

ENV SSH_USERNAME root
ENV SSH_PASSWORD password

# install syncthing
RUN apk add syncthing
USER root
RUN if [ ! -d /sync ]; then mkdir /sync && chmod 777 -R /sync; fi

#install openssh
RUN apk add -U openssh && rc-update add sshd;
RUN echo "${SSH_USERNAME}:${SSH_PASSWORD}" | chpasswd
RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config

EXPOSE 8080 22000 22 21025/udp
ENTRYPOINT syncthing
