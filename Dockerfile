FROM nginx:alpine

EXPOSE 80 443
WORKDIR /root

RUN set -ex && \
    # 初始化
    sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories && \
    export ALL_PROXY=socks5://172.16.0.10:1080 && \
    # 安装必须库
    apk update && \
    apk add openssl && \
    # 安装acme.sh
    mkdir -p /etc/nginx/cert && \
    wget -qO- https://get.acme.sh | sh

COPY root /root
VOLUME [ "/etc/nginx/conf.d" ]
VOLUME [ "/etc/nginx/cert" ]
VOLUME [ "/usr/share/nginx/html" ]
