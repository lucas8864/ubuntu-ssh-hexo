# Ubuntu SSH + Hexo 一键博客系统

本项目基于 Ubuntu 22.04 构建，集成 SSH 服务、Hexo 博客自动部署，支持容器启动即用。

## 功能特色

- SSH 用户初始化（支持自定义用户名/密码）
- 内置 Supervisor 管理进程
- Hexo 自动初始化并启动
- 默认开放端口：
  - 2222：SSH 登录
  - 4000：Hexo 博客访问

## 使用方式
## 1.本地构建镜像启动

```bash
docker compose up -d

## 2.从docker仓库拉取镜像启动
```bash
docker run -it --rm --name ubuntu-ssh-hexo \
    -e $USERNAME=bloguser \ #普通用户
    -e $PASSWORD=blog@123 \ #普通用户密码
    -e $ROOTPASS=root@123  \ #root密码 	
    -p 2222:22 -p 4000:4000 \ #映射端口
    lalucas/ubuntu-ssh-hexo:latest #镜像名称

默认账号
用户名：bloguser
密码：blog@123
博客地址：http://localhost:4000

## claw cloud启动
```bash
Image Name:lalucas/ubuntu-ssh-hexo:latest
CPU:0.2
Memory:256M
Network:
Container Port:2222 & 4000
Environment Variables:
USERNAME=bloguser
PASSWORD=blog@123
ROOTPASS=root@123
Local Storage:1G && /home/bloguser
