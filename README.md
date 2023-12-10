# GatewayZ - 微服务代理

GatewayZ 是一个基于 Traefik 的微服务代理，用于统一管理和代理各个服务器上的后端服务。该代理支持 Docker 部署，并提供了简便的配置方式。

## 安装和运行

### 1. 克隆仓库

```bash
git clone https://github.com/your-username/gatewayz.git
cd gatewayz
```

### 2. 配置 Traefik

在 traefik/traefik.toml 文件中配置 Traefik。可以根据项目需求调整配置，确保 Traefik 能够正确代理你的微服务。

```toml
# traefik.toml

# 入口点定义，这里定义了一个名为 "web" 的入口点，监听在 80 端口上
[entryPoints]
  [entryPoints.web]
    address = ":80"

# 启用 Traefik 仪表板，可以通过 http://<your-node-ip>:8080 访问
[api]
  dashboard = true

# 提供者配置，使用 Docker 作为提供者
[providers.docker]
  endpoint = "unix:///var/run/docker.sock"  # Docker 的通信端点
  exposedByDefault = false  # 默认情况下不暴露容器，需要在微服务中明确标识

# 全局的 TLS 配置，可以在这里定义全局的 TLS 证书等信息
#[tls]
#  [tls.options]
#    [tls.options.default]
#      minVersion = "VersionTLS12"

# 示例：如果需要启用 Let's Encrypt，请添加以下配置
#[certificatesResolvers.myresolver.acme]
#  email = "your-email@example.com"
#  storage = "/acme/acme.json"
#  [certificatesResolvers.myresolver.acme.tlsChallenge]

# 更多配置选项请参考官方文档：https://doc.traefik.io/traefik/providers/docker/#docker-backend

```

### 3. 启动 Traefik 容器

使用 Docker Compose 启动 Traefik 容器：

```shell
docker-compose -f traefik/docker-compose.yml up
docker-compose -f traefik/docker-compose.yml up -d
```

### 4. 部署微服务

   为每个微服务创建 Docker Compose 文件，并确保在其中添加 Traefik 标签以启用代理。示例：

```yaml
version: "3"

services:
  myservice:
    image: myservice:latest
    labels:
      - "traefik.enable=true"
      - "traefik.http.routers.myservice.rule=Host(`myservice.example.com`)"
```

### 5. 验证 Traefik 和微服务

- 访问 Traefik 仪表板：<http://localhost:8080>
- 访问微服务：使用你在微服务中定义的域名在浏览器中访问，例如 myservice.example.com。

## 目录结构

- traefik/: 存放 Traefik 配置文件。
- services/: 存放每个微服务的 Docker Compose 文件和相关配置文件。
- shared/: 存放共享的配置文件，如数据库连接信息等。

## 注意事项

- 确保 Docker 已正确安装并运行。
- 根据实际需求调整 Traefik 和微服务的配置文件。
- 若要使用 HTTPS，请配置 Traefik 证书等相关信息。

## 测试负载均衡

```shell
seq 10 | xargs -I{}  curl -H Host:whoami.docker.localhost http://127.0.0.1
```

## 贡献

欢迎贡献代码、报告问题或提出改进建议。在提交 Pull Request 前，请确保通过相关测试。

## 许可证

[MIT License](https://opensource.org/licenses/MIT)
