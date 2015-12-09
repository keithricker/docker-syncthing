FROM kricker/server-base

ENV SSH_USERNAME root
ENV SSH_PASSWORD password

ENV GUI_USERNAME developer
ENV GUI_PASSWORD password
ENV SYNCDIR /data
ENV PRIVATE_KEY_CONTENTS none

# install syncthing and openssh
RUN apt-get update && apt-get remove apt-listchanges && apt-get install -y curl
RUN cd /tmp && \
    curl -L "https://github.com/syncthing/syncthing/releases/download/v0.11.6/syncthing-linux-amd64-v0.11.6.tar.gz" -O && \
    tar -zvxf "syncthing-linux-amd64-v0.11.6.tar.gz" && \
    mv syncthing-linux-amd64-v0.11.6/syncthing /usr/local/bin/syncthing && \
    mkdir -p /sync/ && \
    apt-get clean -y && \
    apt-get autoclean -y && \
    apt-get autoremove -y && \
    rm -rf /var/lib/{apt,dpkg,cache,log}/ && \
    rm -rf /tmp/*
  
# public key goes here
RUN if [ ! -d "/root/.ssh" ]; then mkdir /root/.ssh; fi
RUN chmod 0700 /root/.ssh

RUN if [ "${PRIVATE_KEY_CONTENTS}" != "none" ]; \
    then echo "${PRIVATE_KEY_CONTENTS}" > ~/.ssh/${PRIVATE_KEY_FILE} \
    sed -i 's/\\n/\/g' ~/.ssh/${PRIVATE_KEY_FILE} \
    chmod 600  ~/.ssh/${PRIVATE_KEY_FILE}; \
    fi

RUN if [ ! -d "/root/Sync" ]; then mkdir root/Sync && chmod 777 /root/Sync; fi
RUN if [ ! -d "/root/.config/syncthing" ]; then mkdir -p /root/.config/syncthing; fi
ADD ./config.xml /root/.config/syncthing/config.xml

VOLUME ["/root/Sync","/root/.ssh"]
EXPOSE 8384 22000 22 21025/udp 21026/udp 22026/udp

ENTRYPOINT sh /root/server-base-start.sh && /sbin/my_init & if [ ! -d "$SYNCDIR" ]; then mkdir "$SYNCDIR"; fi && \
sed -i 's|'/root/Sync'|'$SYNCDIR'|g' /root/.config/syncthing/config.xml && \
syncthing -gui-address=0.0.0.0:8384 -gui-authentication=${GUI_USERNAME}:${GUI_PASSWORD}
