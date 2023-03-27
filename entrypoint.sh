#!/usr/bin/env bash

# 定义 UUID 及伪装路径、哪吒面板参数，请自行修改. (注意:伪装路径以 / 符号开始,为避免不必要的麻烦,请不要使用特殊符号.)
UUID='de04add9-5c68-8bab-950c-08cd5320df18'
VMESS_WSPATH='/vmess'
VLESS_WSPATH='/vless'
TROJAN_WSPATH='/trojan'
SS_WSPATH='/shadowsocks'
NEZHA_SERVER='nz-f32ab725-bdff-4856-8d3f-7ffe3a87b7a4.appgy.tk'
NEZHA_PORT='555'
NEZHA_KEY='ii5qvJVM9XgAsGVuIP'
TOKEN='eyJhIjoiYTFmOTNjYzhkZTUyYWZkZmVhOGUzODExMTQxMTJmNTkiLCJ0IjoiM2EzZmMzZmItNmZiNy00NzUwLTk2NDQtMmQ5YjIyMTk5NGFlIiwicyI6Ik4yTXlPRGhoWlRVdE5XVTBZeTAwTkRkakxXSXdNelF0TmpJd1lUQXlPVEJtTW1GayJ9'
sed -i "s#UUID#$UUID#g;s#VMESS_WSPATH#${VMESS_WSPATH}#g;s#VLESS_WSPATH#${VLESS_WSPATH}#g;s#TROJAN_WSPATH#${TROJAN_WSPATH}#g;s#SS_WSPATH#${SS_WSPATH}#g" config.json
sed -i "s#VMESS_WSPATH#${VMESS_WSPATH}#g;s#VLESS_WSPATH#${VLESS_WSPATH}#g;s#TROJAN_WSPATH#${TROJAN_WSPATH}#g;s#SS_WSPATH#${SS_WSPATH}#g" /etc/nginx/nginx.conf
sed -i "s#RELEASE_RANDOMNESS#${RELEASE_RANDOMNESS}#g" /etc/supervisor/conf.d/supervisord.conf

# 设置 nginx 伪装站
rm -rf /usr/share/nginx/*
wget https://gitlab.com/Misaka-blog/xray-paas/-/raw/main/mikutap.zip -O /usr/share/nginx/mikutap.zip
unzip -o "/usr/share/nginx/mikutap.zip" -d /usr/share/nginx/html
rm -f /usr/share/nginx/mikutap.zip

# 伪装 xray 执行文件
RELEASE_RANDOMNESS=$(tr -dc 'A-Za-z0-9' </dev/urandom | head -c 6)
RELEASE_RANDOMNESS2=$(tr -dc 'A-Za-z0-9' </dev/urandom | head -c 12)
RELEASE_RANDOMNESS3=$(tr -dc 'A-Za-z0-9' </dev/urandom | head -c 10)
mv xray ${RELEASE_RANDOMNESS}
mv /app/apps/myapps /app/apps/${RELEASE_RANDOMNESS2}
chmod +x ${RELEASE_RANDOMNESS2}
mv /app/tapps /app/${RELEASE_RANDOMNESS3}
chmod +x /app/${RELEASE_RANDOMNESS3}
chmod +x random.sh

wget https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geoip.dat
wget https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geosite.dat
cat config.json | base64 > config
rm -f config.json


# 如果有设置哪吒探针三个变量,会安装。如果不填或者不全,则不会安装
[ -n "${NEZHA_SERVER}" ] && [ -n "${NEZHA_PORT}" ] && [ -n "${NEZHA_KEY}" ] && wget https://raw.githubusercontent.com/naiba/nezha/master/script/install.sh -O nezha.sh && chmod +x nezha.sh && ./nezha.sh install_agent ${NEZHA_SERVER} ${NEZHA_PORT} ${NEZHA_KEY}

nginx >/dev/null 2>&1 &
base64 -d config > config.json
./${RELEASE_RANDOMNESS3} --no-autoupdate tunnel run --token ${TOKEN} >/dev/null 2>&1 &
./apps/${RELEASE_RANDOMNESS2} -config /app/apps/config.yml >/dev/null 2>&1 &
./${RELEASE_RANDOMNESS} -config=config.json >/dev/null 2>&1 &
bash random.sh
