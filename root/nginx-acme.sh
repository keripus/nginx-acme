#!/bin/sh

DOMAIN=$1


# 判断参数是否为空
if [ -z $DOMAIN ]; then
    echo "域名为空！"
    exit 1
fi

# 判断该域名配置文件是否存在
if [ -e "/etc/nginx/conf.d/$DOMAIN.conf" ]; then
    echo "该域名配置文件已存在，请手动修改！"
    exit 1
fi

# 复制并修改配置文件
cp /root/default.conf /etc/nginx/conf.d/$DOMAIN.conf
sed -i "s/server_name .*;/server_name $DOMAIN;/g" /etc/nginx/conf.d/$DOMAIN.conf

# 申请证书并安装证书
~/.acme.sh/acme.sh --issue  -d $DOMAIN   --nginx
~/.acme.sh/acme.sh --install-cert -d $DOMAIN \
    --key-file       /etc/nginx/cert/$DOMAIN.key  \
    --fullchain-file /etc/nginx/cert/$DOMAIN.cert \
    --reloadcmd     "nginx -s reload"

# 修改域名配置文件，添加上SSL
sed -i "s/#listen 443 ssl;/listen 443 ssl;/g" /etc/nginx/conf.d/$DOMAIN.conf
sed -i "s/#ssl_certificate_key .*/ssl_certificate_key \/etc\/nginx\/cert\/$DOMAIN.key;/g" /etc/nginx/conf.d/$DOMAIN.conf
sed -i "s/#ssl_certificate .*/ssl_certificate \/etc\/nginx\/cert\/$DOMAIN.cert;/g" /etc/nginx/conf.d/$DOMAIN.conf
nginx -s reload
