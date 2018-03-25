FROM alpine:latest
MAINTAINER Andreas L.

ADD root /

RUN apk add --update nginx openssh && \
    rm -rf /var/cache/apk/* && \
    adduser -D -g 'www' www && \
    mkdir -p /www && \
    chown -R www:www /var/lib/nginx && \
    chown -R www:www /www



# Expose the ports for nginx
EXPOSE 80 443 22

#    mkdir /run/nginx && \
