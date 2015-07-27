FROM kalabox/syncthing:stable

ENV DEBIAN_FRONTEND noninteractive

# The password is password
RUN \
  echo "root:password" | chpasswd && \
  mkdir /var/run/sshd

# Install OpenSSH server
RUN \
  apt-get update && \
  apt-get install -y openssh-server && \
  apt-get clean && rm -rf /var/lib/apt/lists/*

EXPOSE 22

ENTRYPOINT ["/usr/sbin/sshd"]

CMD ["-D", "/bin/bash", "unlink /var/run/supervisor.sock", "/start.sh"]
