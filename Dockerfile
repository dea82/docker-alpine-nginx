FROM alpine:latest
MAINTAINER Andreas L.

ADD root /

RUN apk add --update nginx openssh-server-pam && \
    rm -rf /var/cache/apk/* && \
    adduser -s /sbin/nologin -D -g 'www' www && \
    mkdir -p /www && \
    chown -R www:www /var/lib/nginx && \
    chown -R www:www /home/www/.ssh && \
    chmod 0700 /home/www/.ssh && \
    chown -R www:www /www && \
    chown root:root /www && \
    /usr/local/bin/setup-ssh.sh

# Expose the ports for nginx
EXPOSE 80 6223