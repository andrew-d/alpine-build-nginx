FROM alpine:3.3
MAINTAINER Andrew Dunham <andrew@du.nham.ca>

RUN apk update && \
    apk upgrade && \
    apk add alpine-sdk coreutils && \
    adduser -G abuild -g "Alpine Package Builder" -s /bin/sh -D builder && \
    echo "builder ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers && \
    mkdir -p /var/cache/distfiles && \
    chgrp abuild /var/cache/distfiles && \
    chmod g+w /var/cache/distfiles

ADD . /home/builder/
USER builder
VOLUME /output

# By default, just build recursively
CMD ['/home/builder/build.sh', '-r']
