FROM gbrks/syncthing:latest

ENV SSH_USERNAME root
ENV SSH_PASSWORD password

USER root
RUN mkdir /sync && chmod 777 -R /sync
RUN apk add -U openssh && rc-update add sshd;
RUN echo "${SSH_USERNAME}:${SSH_PASSWORD}" | chpasswd
RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config

CMD ["-no-browser", "-no-restart", "-gui-address=0.0.0.0:8384", "-home=/config"]  
ENTRYPOINT ["/home/syncthing/syncthing"]  
