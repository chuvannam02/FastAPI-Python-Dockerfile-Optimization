FROM node:20-alpine AS a
WORKDIR /app
COPY package*.json .
RUN npm i express redis
COPY index.js .

FROM busybox:1.36-musl
COPY --from=a /app /app
ADD --chmod=0755 https://download.redis.io/releases/redis-7.2.5.tar.gz /r.tgz
RUN tar -xzf /r.tgz -C /usr/local/bin --strip-components=2 redis-7.2.5/src/redis-server && rm /r.tgz
ADD --chmod=0755 https://nginx.org/download/nginx-1.26.2.tar.gz /n.tgz
RUN tar -xzf /n.tgz -C /usr/local/bin --wildcards '*/objs/nginx' --strip-components=3 && rm /n.tgz
COPY nginx.conf /etc/nginx.conf
EXPOSE 80
CMD sh -c "redis-server --save '' --appendonly no & node /app/index.js & nginx -c /etc/nginx.conf"