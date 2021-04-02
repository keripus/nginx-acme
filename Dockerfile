FROM nginx:alpine

EXPOSE 80 443
WORKDIR /root

RUN set -ex \
    # 初始化
    && apk update \
    && apk add openssl \
    # 安装acme.sh
    && mkdir -p /etc/nginx/cert \
    && wget -qO- https://get.acme.sh | sh

COPY root /root
VOLUME [ "/etc/nginx/conf.d" ]
VOLUME [ "/etc/nginx/cert" ]
VOLUME [ "/usr/share/nginx/html" ]
