FROM phusion/baseimage:0.9.15

ENV LANG en_US.UTF-8
ENV BTSUNAME admin
ENV BTSPASS password

RUN locale-gen $LANG

ADD http://download-cdn.getsyncapp.com/stable/linux-x64/BitTorrent-Sync_x64.tar.gz /btsync.tar.gz
RUN tar xf /btsync.tar.gz && \
    rm /btsync.tar.gz

ADD start.sh /start.sh

VOLUME ["/data"]
EXPOSE 3369/udp
EXPOSE 8888

CMD ["/start.sh"]
