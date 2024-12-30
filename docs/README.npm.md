# GatewayZ - Nginx Proxy Manager 实现

本文档介绍如何使用 Nginx Proxy Manager (NPM) 来实现 GatewayZ 的微服务代理功能。NPM 提供了一个漂亮的 Web UI 界面，使得代理配置变得简单直观。

## 功能特点

- 美观且安全的管理界面
- 通过 Web UI 轻松创建转发域名、重定向和流代理
- 支持自动申请 Let's Encrypt SSL 证书
- 支持访问控制列表和基本的 HTTP 认证
- 支持高级 Nginx 配置
- 用户管理、权限控制和审计日志

## 快速开始

### 1. 准备工作

确保您的系统已安装:
- Docker 
- Docker Compose

### 2. 配置环境变量

```bash
cp sample.env .env
```

根据需要修改 .env 文件中的配置。

### 3. 启动服务

我们已经在项目中提供了预配置的 compose.yml：

```yaml
services:
  nginx:
    container_name: gatewayz_nginx
    image: jc21/nginx-proxy-manager:2.12.1
    restart: unless-stopped
    ports:
      - "80:80"   # HTTP 端口
      - "443:443" # HTTPS 端口
      - "81:81"   # 管理界面端口
    volumes:
      - $VOLUMES_DIR./data:/data
      - $VOLUMES_DIR./letsencrypt:/etc/letsencrypt
```

启动服务：

```bash
docker compose up -d
```

### 4. 访问管理界面

1. 打开浏览器访问: `http://您的服务器IP:81`

2. 使用默认管理员账号登录:
   - 邮箱: `admin@example.com`
   - 密码: `changeme`

3. 首次登录后，系统会要求您修改管理员密码和邮箱。

## 配置代理

### 添加代理主机

1. 在管理界面中点击 "Proxy Hosts"
2. 点击 "Add Proxy Host" 按钮
3. 填写配置信息：
   - Domain Names: 输入访问域名
   - Scheme: 选择 http 或 https
   - Forward Hostname/IP: 目标服务的主机名或IP
   - Forward Port: 目标服务端口
   - 按需配置 SSL 证书

### SSL 证书配置

1. 在 "SSL" 选项卡中：
   - 可以选择自动申请 Let's Encrypt 证书
   - 或上传自己的证书
2. 建议启用 "Force SSL" 选项强制 HTTPS 访问

## 进阶配置

### 访问控制

1. 可以在 "Access Lists" 中创建访问控制规则
2. 支持 IP 白名单/黑名单
3. 可以设置基本认证(用户名密码)

### 自定义 Nginx 配置

1. 在代理主机的 "Advanced" 选项卡中
2. 可以添加自定义的 Nginx 配置
3. 支持添加自定义 locations 等高级配置

## 注意事项

1. 域名解析
   - 确保域名已正确解析到服务器IP
   - 使用 Let's Encrypt 证书需要域名可以公网访问

2. 端口配置
   - 确保 80/443 端口未被占用
   - 检查防火墙是否放行相关端口

3. 安全建议
   - 及时修改默认管理员密码
   - 建议限制管理界面(81端口)的访问来源
   - 定期备份数据目录

## 故障排查

1. 无法访问管理界面
   - 检查防火墙配置
   - 确认容器运行状态
   - 查看容器日志

2. SSL 证书申请失败
   - 确认域名解析是否生效
   - 检查 80 端口是否可访问
   - 查看证书申请日志

## 参考资料

- [Nginx Proxy Manager 官方文档](https://nginxproxymanager.com/guide/)
- [Docker Hub 镜像地址](https://hub.docker.com/r/jc21/nginx-proxy-manager)

## 许可证

[MIT License](https://opensource.org/licenses/MIT)
