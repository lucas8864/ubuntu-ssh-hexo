#!/usr/bin/env bash
set -e

# 接收外部用户和密码参数
USERNAME=${SSH_USER:-bloguser}
PASSWORD=${SSH_PASSWORD:-blogpass}
ROOTPASS=${ROOT_PASSWORD:-rootpass}

# 切换回阿里云 npm 源
npm config set registry https://registry.npmmirror.com

# 创建普通用户
if ! id "$USERNAME" &>/dev/null; then
  useradd -m -s /bin/bash "$USERNAME"
  echo "$USERNAME:$PASSWORD" | chpasswd
  usermod -aG sudo "$USERNAME"
  # 拷贝默认 shell 配置
  cp /etc/skel/.bashrc /home/"$USERNAME"/.bashrc
  cp /etc/skel/.profile /home/"$USERNAME"/.profile
  chown "$USERNAME:$USERNAME" /home/"$USERNAME"/.bashrc /home/"$USERNAME"/.profile
fi

# 设置 root 密码并启用 SSH 登录
echo "root:$ROOTPASS" | chpasswd
sed -i 's/^#PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config
sed -i 's/^#PasswordAuthentication.*/PasswordAuthentication yes/' /etc/ssh/sshd_config
#sed -i '/ff/d;/::/d' /etc/hosts
cp /etc/hosts /tmp/hosts.bak && grep -vE '::|ff' /tmp/hosts.bak > /etc/hosts

# 启动后台服务：sshd + Hexo + supervisor
/usr/sbin/sshd

if [ ! -d "/home/${USERNAME}/blog" ]; then
    echo "📁 初始化 Hexo 博客项目..."
    sudo -u ${USERNAME} hexo init /home/${USERNAME}/blog
    cd /home/${USERNAME}/blog
    sudo -u ${USERNAME} npm install
else
    echo "✅ Hexo 博客已存在，跳过初始化。"
fi

# 启动 Hexo 服务监听所有 IP
cd /home/${USERNAME}/blog
sudo -u "${USERNAME}" hexo server -i 0.0.0.0 -p 4000 &

#启动supervisor
exec /usr/bin/supervisord -n -c /etc/supervisor/conf.d/supervisord.conf

# 阻塞容器运行状态
tail -f /dev/null
