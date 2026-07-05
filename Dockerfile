FROM node:alpine

WORKDIR /app

# 安装 unzip + 必要工具
# 把 xray 二进制和 geo 数据文件打包到镜像里（支持 amd64 和 arm64）
RUN apk add --no-cache openssl curl gcompat iproute2-minimal coreutils bash ca-certificates unzip && \
    ARCH=$(uname -m) && \
    if [ "$ARCH" = "x86_64" ]; then \
      XRAY_URL="https://github.com/XTLS/Xray-core/releases/latest/download/Xray-linux-64.zip"; \
    elif [ "$ARCH" = "aarch64" ]; then \
      XRAY_URL="https://github.com/XTLS/Xray-core/releases/latest/download/Xray-linux-arm64-v8a.zip"; \
    else \
      echo "Unsupported architecture: $ARCH" && exit 1; \
    fi && \
    curl -L -o /tmp/xray.zip "$XRAY_URL" && \
    unzip /tmp/xray.zip -d /tmp/xray_extracted/ && \
    mv /tmp/xray_extracted/xray /usr/local/bin/xray && \
    mv /tmp/xray_extracted/geoip.dat /app/geoip.dat && \
    mv /tmp/xray_extracted/geosite.dat /app/geosite.dat && \
    chmod +x /usr/local/bin/xray && \
    rm -rf /tmp/xray.zip /tmp/xray_extracted

COPY . .

RUN npm install

EXPOSE 3000

CMD ["node", "index.js"]
