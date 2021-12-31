FROM nginx:1.19.6-alpine

RUN apk update \
    && apk upgrade \
	&& apk add --update alpine-sdk \
    && apk add --update logrotate \
    && apk add --no-cache openssl \
    && apk add --no-cache bash \
	&& apk add --no-cache gcc \
	&& apk add --no-cache libc-dev \
	&& apk add --no-cache pcre-dev \
	&& apk add --no-cache openssl-dev \
	&& apk add --no-cache zlib-dev

RUN apk add --no-cache curl

WORKDIR /tmp

RUN wget https://nginx.org/download/nginx-1.19.6.tar.gz \
	&& wget https://github.com/wandenberg/nginx-push-stream-module/archive/0.5.4.tar.gz \
	&& tar -xf nginx-1.19.6.tar.gz \
	&& tar -xf 0.5.4.tar.gz

RUN cd nginx-1.19.6 \
	&& ./configure --prefix=/etc/nginx --sbin-path=/usr/sbin/nginx --modules-path=/usr/lib/nginx/modules --conf-path=/etc/nginx/nginx.conf --error-log-path=/var/log/nginx/error.log --http-log-path=/var/log/nginx/access.log --pid-path=/var/run/nginx.pid --lock-path=/var/run/nginx.lock --http-client-body-temp-path=/var/cache/nginx/client_temp --http-proxy-temp-path=/var/cache/nginx/proxy_temp --http-fastcgi-temp-path=/var/cache/nginx/fastcgi_temp --http-uwsgi-temp-path=/var/cache/nginx/uwsgi_temp --http-scgi-temp-path=/var/cache/nginx/scgi_temp --with-perl_modules_path=/usr/lib/perl5/vendor_perl --user=nginx --group=nginx --with-compat --with-threads --with-http_addition_module --with-http_auth_request_module --with-http_dav_module --with-http_flv_module --with-http_gunzip_module --with-http_gzip_static_module --with-http_mp4_module --with-http_random_index_module --with-http_realip_module --with-http_secure_link_module --with-http_slice_module --with-http_ssl_module --with-http_stub_status_module --with-http_sub_module --with-http_v2_module --with-mail --with-mail_ssl_module --with-stream --with-stream_realip_module --with-stream_ssl_module --with-stream_ssl_preread_module --with-cc-opt='-Os -fomit-frame-pointer' --with-ld-opt=-Wl,--as-needed --add-dynamic-module=../nginx-push-stream-module-0.5.4 \
	&& make modules \
	&& cp objs/ngx_http_push_stream_module.so /usr/lib/nginx/modules/

# Configure www user.
ARG PUID=1111
ARG PGID=1111
RUN set -x ; \
    addgroup -g ${PGID} -S www ; \
    adduser -u ${PUID} -D -S -G www www && exit 0 ; exit 1

RUN rm /etc/nginx/conf.d/default.conf \
	&& rm /etc/nginx/fastcgi.conf

# Set Timezone
ARG TZ=UTC
RUN ln -snf /usr/share/zoneinfo/${TZ} /etc/localtime && echo ${TZ} > /etc/timezone

COPY nginx.conf /etc/nginx/

COPY sites /etc/nginx/sites-available

COPY index.html /usr/share/nginx/html/index.html

ADD ./startup.sh /opt/startup.sh
RUN sed -i 's/\r//g' /opt/startup.sh

CMD ["/bin/bash", "/opt/startup.sh"]

EXPOSE 80
