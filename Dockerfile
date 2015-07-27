FROM kricker-mini-server-base:latest

ENV SSH_USERNAME root
ENV SSH_PASSWORD password

ENV VERSION v0.11.16

# Add user to run syncthing as, must exist on host and have access to files
RUN cd ~/ && adduser -D -u 1000 syncthing users

# Add dependencies 
RUN apk add --update ca-certificates \

# Add build environment 
    --virtual build_go \
        git godep go mercurial bash && \
    rm -rf /var/cache/apk/* && \

# Download from Github and build
    mkdir -p /go/src/github.com/syncthing && \
    cd /go/src/github.com/syncthing && \
    git clone https://github.com/syncthing/syncthing.git && \
    cd syncthing && \
    git checkout $VERSION && \
    go run build.go && \
    mv bin/syncthing /home/syncthing/syncthing && \
    chown syncthing:syncthing /home/syncthing/syncthing && \

# Clean up
    rm -rf /go && \
    apk del build_go

# install openssh
USER root
RUN if [ ! -d /sync ]; then mkdir /sync && chmod 777 -R /sync; fi
RUN apk add -U openssh && rc-update add sshd;
RUN echo "${SSH_USERNAME}:${SSH_PASSWORD}" | chpasswd
RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config

EXPOSE 8384 22000 22 21025/udp
VOLUME /config
CMD ["-no-browser", "-no-restart", "-gui-address=0.0.0.0:8384", "-home=/config"]  
ENTRYPOINT ["/home/syncthing/syncthing"]  
