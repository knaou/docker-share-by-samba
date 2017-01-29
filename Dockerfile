FROM alpine
MAINTAINER naou <monaou@gmail.com>

RUN apk add --no-cache samba

COPY start.sh /start.sh

CMD ["/start.sh"]

VOLUME /share

#EXPOSE 137/udp
#EXPOSE 138/udp
#EXPOSE 139/tcp
EXPOSE 445/tcp


