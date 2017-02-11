FROM openresty/openresty:xenial

RUN apt-get update && apt-get install -y wget openssl curl

ENV DOCKERIZE_VERSION v0.3.0
RUN wget https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && tar -C /usr/local/bin -xzvf dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && rm dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz

RUN /usr/local/openresty/luajit/bin/luarocks install lua-resty-auto-ssl
RUN mkdir /etc/resty-auto-ssl && chown www-data /etc/resty-auto-ssl
RUN yes "" | openssl req -new -newkey rsa:2048 -days 3650 -nodes -x509 -subj '/CN=err-letsencrypt-has-failed' -keyout /fb.key -out fb.crt

ADD nginx.tmpl /nginx.tmpl
ADD auth.tmpl /auth.tmpl

RUN mkdir /auth

ENTRYPOINT dockerize -template /nginx.tmpl:/usr/local/openresty/nginx/conf/nginx.conf -template /auth.tmpl:/auth.sh && chmod +x /auth.sh && /auth.sh && /usr/local/openresty/bin/openresty
