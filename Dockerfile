FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive \
    TZ=Asia/Shanghai

# 先安装基础依赖（保留默认源）
RUN apt-get update && \
    apt-get install -y ca-certificates gnupg && \
    apt-get clean

# 切换为阿里云源（此时有 ca-certificates 可用）
RUN sed -i 's|http://archive.ubuntu.com|https://mirrors.aliyun.com|g' /etc/apt/sources.list && \
    sed -i 's|http://security.ubuntu.com|https://mirrors.aliyun.com|g' /etc/apt/sources.list

# 再次更新并安装主工具集
RUN apt-get update && \
    apt-get install -y tzdata openssh-server sudo curl wget vim net-tools unzip cron supervisor git \
    && curl -fsSL https://deb.nodesource.com/setup_18.x | bash - \
    && apt-get install -y nodejs \
    && npm install -g hexo-cli \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# 全局安装 Hexo CLI
RUN npm config set registry https://registry.npmmirror.com && npm install -g hexo-cli

#复制文件
COPY entrypoint.sh /entrypoint.sh
COPY reboot.sh /usr/local/bin/reboot
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY ./templates/bashrc /etc/skel/.bashrc
COPY ./templates/profile /etc/skel/.profile
RUN mkdir -p /var/log/supervisor && \
    mkdir -p /run/sshd && \
    chmod +x /entrypoint.sh /usr/local/bin/reboot && \
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && \
    echo $TZ > /etc/timezone

EXPOSE 22 4000

# 只做镜像构建，用户创建交由 entrypoint.sh 处理
ENTRYPOINT ["/entrypoint.sh"]
CMD ["/usr/bin/supervisord", "-n", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
