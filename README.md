# GatewayZ - 微服务代理

GatewayZ 是一个灵活的微服务代理平台，支持多种实现方案，用于统一管理和代理各个服务器上的后端服务。

## 实现方案

目前支持以下实现方案，您可以根据需求选择合适的方案：

- [基于 Traefik 的实现](docs/README.traefik.md) - 轻量级、自动服务发现
- [基于 Nginx Proxy Manager 的实现](docs/README.npm.md) - 可视化配置界面

## 快速开始

### 1. 克隆仓库

```bash
git clone https://github.com/sichang824/gatewayz
cd gatewayz
```

### 2. 选择实现方案

根据您的需求选择合适的实现方案，并参考对应的文档进行配置：

- Traefik 方案：查看 [Traefik 实现文档](docs/README.traefik.md)
- Nginx Proxy Manager 方案：查看 [NPM 实现文档](docs/README.npm.md)

## 目录结构

```
.
├── docs/                    # 详细文档
│   ├── README.traefik.md   # Traefik 实现文档
│   └── README.npm.md       # Nginx Proxy Manager 实现文档
├── traefik/                # Traefik 相关配置
├── services/               # 微服务配置目录
├── shared/                 # 共享配置文件
└── README.md              # 项目说明
```

## 方案对比

| 特性 | Traefik | Nginx Proxy Manager |
|------|---------|-------------------|
| 配置方式 | 文件配置 | 可视化界面 |
| 自动发现 | 支持 | 不支持 |
| SSL 管理 | 支持 | 支持(自动化) |
| 学习曲线 | 中等 | 简单 |
| 适用场景 | 大规模微服务 | 小型项目 |

## 注意事项

- 确保 Docker 和 Docker Compose 已正确安装
- 选择适合您需求的实现方案
- 在生产环境中建议启用 HTTPS
- 定期备份配置文件

## 贡献

欢迎贡献代码、报告问题或提出改进建议。在提交 Pull Request 前，请确保通过相关测试。

## 许可证

[MIT License](https://opensource.org/licenses/MIT)
