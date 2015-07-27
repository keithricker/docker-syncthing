FROM gbrks/syncthing:latest

ENV SSH_USERNAME, root
ENV SSH_PASSWORD, password

CMD ["-no-browser", "-no-restart", "-gui-address=0.0.0.0:8384", "-home=/config"]  
ENTRYPOINT ["/home/syncthing/syncthing"]  

USER root
RUN apk add -U openssh && \
rc-update add sshd && \
sudo echo "${sshuname}:${sshpass}" | /tmp chpasswd && \
sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \
mkdir -p /root/.ssh/ && touch /root/.ssh/authorized_keys;
