# 使用Alpine作为基础镜像以减小体积
FROM alpine:3.19

# 安装Redis和tzdata(时区数据)
RUN apk add --no-cache 'redis~=7.2' tzdata

# 设置时区为上海
ENV TZ=Asia/Shanghai

# 预先设置时区，这样就不需要在运行时设置了
RUN cp /usr/share/zoneinfo/$TZ /etc/localtime && \
    echo $TZ > /etc/timezone

# 创建数据和配置目录
RUN mkdir -p /data /etc/redis && \
    chown -R redis:redis /data /etc/redis

# 添加配置文件
COPY redis.conf /etc/redis/redis.conf.template
COPY docker-entrypoint.sh /usr/local/bin/

# 设置适当的权限
RUN chmod +x /usr/local/bin/docker-entrypoint.sh && \
    chown redis:redis /etc/redis/redis.conf.template

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