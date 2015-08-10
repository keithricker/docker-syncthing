FROM sillelien/jessy:master

ENV SSH_USERNAME root
ENV SSH_PASSWORD password

ENV GUI_USERNAME developer
ENV GUI_PASSWORD password

ENV SYNCDIR /root/Sync

# install syncthing and openssh
RUN apt-get update && apt-get remove apt-listchanges && apt-get install -y curl
RUN apt-get install -y openssh-server && cd /tmp && \
    curl -L "https://github.com/syncthing/syncthing/releases/download/v0.11.6/syncthing-linux-amd64-v0.11.6.tar.gz" -O && \
    tar -zvxf "syncthing-linux-amd64-v0.11.6.tar.gz" && \
    mv syncthing-linux-amd64-v0.11.6/syncthing /usr/local/bin/syncthing && \
    mkdir -p /sync/ && \
    apt-get clean -y && \
    apt-get autoclean -y && \
    apt-get autoremove -y && \
    rm -rf /var/lib/{apt,dpkg,cache,log}/ && \
    rm -rf /tmp/*

RUN echo "${SSH_USERNAME}:${SSH_PASSWORD}" | chpasswd
RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -ri 's/^PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config
# public key goes here
RUN mkdir /root/.ssh
RUN chmod 0700 /root/.ssh

RUN if [ ! -d "/root/Sync" ]; then mkdir root/Sync && chmod 777 /root/Sync; fi
VOLUME ["/root/Sync","/root/.ssh"]
EXPOSE 8384 22000 22 21025/udp

ENTRYPOINT [ -d "$SYNCDIR" ] || ln -s /root/Sync "$SYNCDIR"; syncthing -gui-address=0.0.0.0:8384 -gui-authentication=${GUI_USERNAME}:${GUI_PASSWORD}
CMD ["/usr/sbin/sshd", "-D"]
