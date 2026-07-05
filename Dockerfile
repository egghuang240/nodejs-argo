FROM node:alpine

WORKDIR /app

# 安装 unzip 和必要工具
# 把 xray 二进制打包到镜像里（运行时不用下载）
RUN apk add --no-cache openssl curl gcompat iproute2 coreutils bash ca-certificates unzip && \
    curl -L -o /tmp/xray.zip \
      https://github.com/XTLS/Xray-core/releases/latest/download/Xray-linux-64.zip && \
    unzip /tmp/xray.zip -d /tmp/ && \
    mv /tmp/xray /usr/local/bin/xray && \
    chmod +x /usr/local/bin/xray && \
    rm /tmp/xray.zip

COPY . .

RUN npm install

EXPOSE 3000

CMD ["node", "index.js"]
