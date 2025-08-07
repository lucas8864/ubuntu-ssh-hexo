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

```bash
docker compose up -d
