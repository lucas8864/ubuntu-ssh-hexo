# Ubuntu SSH + Hexo 一键博客系统

本项目基于 Ubuntu 22.04 构建，集成 SSH 服务与 Hexo 博客自动部署，容器启动即用，适用于快速部署个人博客或技术分享平台。

## 🔧 功能特色

- ✅ SSH 用户自动初始化（支持自定义用户名、密码）
- ✅ Supervisor 管理 SSH 与 Hexo 服务
- ✅ Hexo 自动初始化、安装依赖并启动博客服务
- ✅ 默认开放端口：
  - `2222`：SSH 登录端口（映射至容器的 22）
  - `4000`：Hexo 博客访问端口

## 🚀 快速开始

### 方法一：本地构建并启动

```bash
git clone https://github.com/lucas8864/ubuntu-ssh-hexo.git
cd ubuntu-ssh-hexo
docker compose up -d
```

### 方法二：从 Docker Hub 拉取镜像启动

```bash
docker run -it --rm --name ubuntu-ssh-hexo     -e USERNAME=bloguser \
    -e PASSWORD=blog@123 \
    -e ROOTPASS=root@123  \
    -p 2222:22 -p 4000:4000     lalucas/ubuntu-ssh-hexo:latest
```

### 默认账户信息

- 普通用户：`bloguser`
- 普通密码：`blog@123`
- root 密码：`root@123`
- 博客地址：[http://localhost:4000](http://localhost:4000)

### 🧩 Cloud Claw 启动参数

- 镜像名称：`lalucas/ubuntu-ssh-hexo:latest`
- CPU：0.2 Core
- 内存：256M
- 容器端口：22 & 4000
- 本地存储：1G 映射至 `/home/bloguser`
- 环境变量：
  ```env
  SSH_NAME=bloguser
  SSH_PASSWORD=blog@123
  ROOT_PASSWORD=root@123
  ```

## 📁 目录结构

```
.
├── Dockerfile
├── docker-compose.yml
├── entrypoint.sh
├── reboot.sh
├── supervisord.conf
├── templates/
│   ├── bashrc
│   └── profile
└── README.md
```

## 📌 注意事项

- Hexo 博客初始化目录为 `/home/bloguser/blog`
- 若已初始化成功，重新启动容器不会重复安装
- 可修改 entrypoint.sh 实现主题切换、部署扩展

---

Made with ❤️ by [lucas8864](https://github.com/lucas8864)
