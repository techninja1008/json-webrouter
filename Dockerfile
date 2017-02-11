FROM openresty/openresty:xenial

RUN apt-get update && apt-get install -y wget openssl curl

ENV DOCKERIZE_VERSION v0.3.0
RUN wget https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && tar -C /usr/local/bin -xzvf dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && rm dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz

RUN luarocks install lua-resty-auto-ssl
RUN mkdir /etc/resty-auto-ssl

ADD nginx.tmpl /nginx.tmpl

ENTRYPOINT dockerize -template /nginx.tmpl:/usr/local/openresty/nginx/conf/nginx.conf && /usr/local/openresty/bin/openresty
