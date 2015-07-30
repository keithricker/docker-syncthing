FROM sillelien/jessy:master

ENV SSH_USERNAME root
ENV SSH_PASSWORD password

ENV GUI_USERNAME ncsaadmin
ENV GUI_PASSWORD youaintready

# install syncthing and openssh
RUN apt-get update && apt-get remove apt-listchanges && apt-get install -y curl
RUN curl -s https://syncthing.net/release-key.txt | pt-key add -
RUN echo "deb http://apt.syncthing.net/ syncthing release" | sudo tee /etc/apt/sources.list.d/syncthing-release.list
RUN apt-get update && apt-get install -y syncthing openssh-server
RUN mkdir /var/run/sshd

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

ENTRYPOINT syncthing -gui-address=0.0.0.0:8384 -gui-authentication=${GUI_USERNAME}:${GUI_PASSWORD}
CMD ["/usr/sbin/sshd", "-D"]
