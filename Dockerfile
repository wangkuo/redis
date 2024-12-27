# 使用Alpine作为基础镜像以减小体积
FROM alpine:3.19

# 安装Redis和tzdata(时区数据)
RUN apk add --no-cache redis=7.2.4-r0 tzdata

# 设置时区为上海
ENV TZ=Asia/Shanghai

# 创建数据目录
RUN mkdir -p /data && chown redis:redis /data

# 添加配置文件
COPY redis.conf /etc/redis/redis.conf

# 添加启动脚本
COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

# 设置工作目录
WORKDIR /data

# 设置数据卷
VOLUME ["/data"]

# 暴露Redis端口
EXPOSE 6379

# 使用redis用户运行
USER redis

# 设置启动命令
ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["redis-server", "/etc/redis/redis.conf"] 