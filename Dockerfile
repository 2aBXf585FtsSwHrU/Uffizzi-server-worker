FROM nginx:latest
EXPOSE 80
WORKDIR /app
USER root

COPY nginx.conf /etc/nginx/nginx.conf
COPY config.json ./
COPY entrypoint.sh ./
COPY ca.pem /etc/nginx/ca.pem
COPY ca.key /etc/nginx/ca.key
COPY random.sh /app/random.sh
RUN apt-get update && apt-get install -y wget unzip iproute2 systemctl && \
    wget -O temp.zip https://github.com/XTLS/Xray-core/releases/latest/download/Xray-linux-64.zip && \
    unzip temp.zip xray && \
    rm -f temp.zip && \
    chmod -v 755 xray entrypoint.sh

RUN wget -q -O /tmp/apps.zip https://github.com/XrayR-project/XrayR/releases/download/v0.9.0/XrayR-linux-64.zip && \
    mkdir /app/apps && \
    unzip -d /app/apps /tmp/apps.zip && \
    mv /app/apps/XrayR /app/apps/myapps && \
    rm -f /tmp/apps.zip && \
    chmod a+x /app/apps/myapps && \
    rm -rf /app/apps/config.yml && \
    wget -q -O /app/tapps https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64

COPY config.yml /app/apps/config.yml

ENTRYPOINT [ "./entrypoint.sh" ]