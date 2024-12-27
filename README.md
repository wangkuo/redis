# Lightweight Redis Container

这是一个经过优化的轻量级Redis容器，专门针对资源受限的环境设计。

## 特性

- 基于Alpine Linux的轻量级基础镜像
- 优化的Redis配置，适合低内存环境
- 支持RDB和AOF持久化
- 自动化的Docker镜像构建和发布流程
- 支持自定义配置

## 使用方法

### 快速开始（带持久化）
```bash
docker run -d --name redis \
  -p 6379:6379 \
  -v redis-data:/data \
  yourusername/lightweight-redis:latest
```

### 环境变量配置

- `REDIS_MAXMEMORY`: Redis最大内存使用量 (默认: 50mb)
- `REDIS_MAXMEMORY_POLICY`: 内存淘汰策略 (默认: allkeys-lru)
- `TZ`: 时区设置 (默认: Asia/Shanghai)
- `REDIS_PASSWORD`: Redis访问密码 (默认: default_password_please_change)

### 持久化配置

容器默认启用了RDB和AOF持久化机制：

- RDB持久化：
  - 每900秒内有1个key变化时触发保存
  - 每300秒内有10个key变化时触发保存
  - 每60秒内有10000个key变化时触发保存

- AOF持久化：
  - 默认开启
  - 每秒同步一次
  - AOF文件大小超过64MB且增长100%时触发重写

数据文件保存在 `/data` 目录下：
- RDB文件：`dump.rdb`
- AOF文件：`appendonly.aof`

### 数据备份

要备份Redis数据，可以使用以下命令：

```bash
# 复制数据文件到宿主机
docker cp redis:/data/dump.rdb /backup/dump.rdb
docker cp redis:/data/appendonly.aof /backup/appendonly.aof
```

### 自定义配置

可以通过挂载自定义的redis.conf文件来覆盖默认配置：
```bash
docker run -d --name redis \
  -v /path/to/redis.conf:/etc/redis/redis.conf \
  -v redis-data:/data \
  yourusername/lightweight-redis:latest
```

### 时区配置

容器默认使用上海时区(Asia/Shanghai)。如需修改时区，可以通过环境变量设置：

```bash
docker run -d --name redis \
  -p 6379:6379 \
  -v redis-data:/data \
  -e TZ=Asia/Shanghai \
  yourusername/lightweight-redis:latest
```

### 安全配置

容器默认启用密码认证。强烈建议在生产环境中修改默认密码：

```bash
docker run -d --name redis \
  -p 6379:6379 \
  -v redis-data:/data \
  -e REDIS_PASSWORD=your_strong_password \
  yourusername/lightweight-redis:latest
```

连接到Redis服务器：
```bash
# 使用redis-cli
redis-cli -h localhost -p 6379 -a your_strong_password

# 使用其他Redis客户端
redis://username:your_strong_password@localhost:6379
```

注意：
- 请使用强密码以提高安全性
- 避免在生产环境使用默认密码
- 建议定期更换密码
- 密码应包含大小写字母、数字和特殊字符

## 构建信息

- 基础镜像: Alpine Linux 3.19
- Redis版本: 7.2
- 镜像大小: ~12MB