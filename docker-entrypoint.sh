#!/bin/sh
set -e

# 设置时区
cp /usr/share/zoneinfo/$TZ /etc/localtime
echo $TZ > /etc/timezone

# 允许通过环境变量覆盖配置
if [ ! -z "$REDIS_MAXMEMORY" ]; then
    sed -i "s/maxmemory .*/maxmemory $REDIS_MAXMEMORY/g" /etc/redis/redis.conf
fi

if [ ! -z "$REDIS_MAXMEMORY_POLICY" ]; then
    sed -i "s/maxmemory-policy .*/maxmemory-policy $REDIS_MAXMEMORY_POLICY/g" /etc/redis/redis.conf
fi

# 执行redis-server
exec "$@" 