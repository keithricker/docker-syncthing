FROM alpine:latest
RUN apk --update add bash

ENV LANG en_US.UTF-8
ENV BTSUNAME admin
ENV BTSPASS password

ADD https://download-cdn.getsyncapp.com/stable/linux-x64/BitTorrent-Sync_x64.tar.gz /btsync.tar.gz
RUN tar xf /btsync.tar.gz && \
    rm /btsync.tar.gz

ADD config/start.sh /start.sh

RUN mkdir /data && chmod 777 /data
VOLUME ["/data"]

EXPOSE 3369/udp
EXPOSE 8888

CMD ["/start.sh"]
