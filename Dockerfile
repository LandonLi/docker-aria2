FROM ubuntu:latest as builder

RUN apt update && \
    apt install -y --fix-missing curl wget libssl-dev libssh2-1-dev libc-ares-dev libxml2-dev zlib1g-dev libsqlite3-dev pkg-config libcppunit-dev autoconf automake autotools-dev autopoint libtool liblzma-dev ca-certificates upx && \
    curl -s https://api.github.com/repos/aria2/aria2/releases/latest | grep -E "browser_download_url.*\.tar\.gz" | cut -d : -f 2,3 | xargs wget -q && \
    tar -xzf aria2*.tar.gz && \
    rm aria2*.tar.gz && \
    cd aria2* && \
    autoreconf -i && \
    ./configure ARIA2_STATIC=yes && \
    make  && \
    upx --best --ultra-brute ./src/aria2c 

FROM alpine:latest

LABEL maintainer "Xiaoxia Li <lxx4work@gmail.com>"

COPY --from=builder /aria2*/src/aria2c /usr/bin/aria2c
COPY aria2.conf /root/
COPY update_trackers.sh /root/
COPY init.sh /root/

RUN chmod +x /usr/bin/aria2c && \
    chmod +x /root/update_trackers.sh && \
    chmod +x /root/init.sh && \ 
    apk add ca-certificates curl && \
    update-ca-certificates && \ 
    rm -rf /var/cache/apk/* 

EXPOSE 6800 6881 6881/udp

VOLUME /etc/aria2 /downloads

CMD ["/bin/sh", "/root/init.sh"]
