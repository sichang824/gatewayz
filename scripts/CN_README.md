## Bash 部署脚本

## 概述

此 Bash 脚本旨在简化 Docker 化应用的部署、管理和升级过程。它包含拉取最新代码、启动、停止、重启应用以及检查应用状态的功能。通过允许用户将 Git 分支作为配置变量进行指定，脚本现在具有更强大的可配置性。

## 先决条件

在使用此脚本之前，请确保满足以下先决条件：

- **Git：** 确保在系统上安装了 Git。
- **Docker：** 确保已安装并配置 Docker。

## 配置

在脚本中，您可以找到一个配置部分，您可以根据项目的需要自定义某些变量：

```shell
# 配置
BRANCH_NAME="main"  # 默认分支名，根据需要修改
```

调整 `BRANCH_NAME` 变量以匹配您项目中使用的默认分支。

## 用法

### 运行脚本

```shell
./deploy.sh [action]
```

将 `[action]` 替换为以下之一：

- `start`：启动应用。
- `stop`：停止应用。
- `restart`：重启应用。
- `check`：检查应用状态。
- `upgrade`：通过拉取最新代码升级应用。

### 自定义

- 通过在配置部分修改 `BRANCH_NAME` 变量，脚本允许自定义默认分支。

- 确保项目结构和 `.env` 文件已适当设置以加载环境变量。

- 您可以根据特定项目需求进一步自定义脚本。

## 重要提示

- 确保脚本具有可执行权限。如果没有，请运行 `chmod +x deploy.sh` 授予执行权限。

- 对于 `check` 操作，可以将容器名称作为可选参数指定。如果未提供，默认使用容器的默认名称。

## 示例

### 启动应用

```shell
./deploy.sh start
```

### 停止应用

```shell
./deploy.sh stop
```

### 重启应用

```shell
./deploy.sh restart
```

### 检查应用状态

```shell
./deploy.sh check [optional_container_name]
```

### 升级应用

```shell
./deploy.sh upgrade
```

## 许可证

此脚本采用 [MIT 许可证](https://chat.openai.com/share/LICENSE) 提供。
