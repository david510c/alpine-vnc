FROM node:alpine
ADD /apk /apk
RUN cp /apk/.abuild/-58b7ee0c.rsa.pub /etc/apk/keys
RUN apk --update add /apk/ossp-uuid-1.6.2-r0.apk
RUN apk add /apk/ossp-uuid-dev-1.6.2-r0.apk
RUN apk add /apk/x11vnc-0.9.13-r0.apk
RUN apk add xvfb openbox xfce4-terminal supervisor sudo \
&& addgroup alpine \
&& adduser  -G alpine -s /bin/sh -D alpine \
&& echo "alpine:alpine" | /usr/sbin/chpasswd \
&& echo "alpine    ALL=(ALL) ALL" >> /etc/sudoers \
&& rm -rf /apk /tmp/* /var/cache/apk/*

RUN npm install -g https://github.com/rootStar-lock/angular-noVNC/tarball/master
RUN websockify --web=.. 8080 localhost:5900

ADD etc /etc

WORKDIR /home/alpine
EXPOSE 8080 5900
USER alpine
CMD ["/usr/bin/supervisord","-c","/etc/supervisord.conf"]
