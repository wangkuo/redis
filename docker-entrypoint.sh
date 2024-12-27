#!/bin/sh
set -e

# 设置默认密码
if [ -z "$REDIS_PASSWORD" ]; then
    REDIS_PASSWORD="default_password_please_change"
fi

# 替换配置文件中的密码
sed -i "s/\${REDIS_PASSWORD}/$REDIS_PASSWORD/g" /etc/redis/redis.conf

# 允许通过环境变量覆盖配置
if [ ! -z "$REDIS_MAXMEMORY" ]; then
    sed -i "s/maxmemory .*/maxmemory $REDIS_MAXMEMORY/g" /etc/redis/redis.conf
fi

if [ ! -z "$REDIS_MAXMEMORY_POLICY" ]; then
    sed -i "s/maxmemory-policy .*/maxmemory-policy $REDIS_MAXMEMORY_POLICY/g" /etc/redis/redis.conf
fi

# 执行redis-server
exec "$@" 