#!/bin/bash
# 设置变量
USERNAME="wobure"
PASSWORD="wobure"
CPOLAR_TOKEN="Zjg0MTQ3NDgtYTNjZC00MjBiLTg5ZWYtOGY0OWJkZmQwODAy"

# 创建新用户
# echo "创建用户 $USERNAME..."
# sudo adduser --gecos "" --disabled-password $USERNAME
# echo "$USERNAME:$PASSWORD" | sudo chpasswd

# # 更新并安装SSH服务
# echo "安装SSH服务..."
# sudo apt-get update && sudo apt-get install -y openssh-server

# # 配置SSH
# echo "配置SSH..."
# sudo mkdir -p /var/run/sshd
# echo 'PermitRootLogin yes' | sudo tee -a /etc/ssh/sshd_config

# # 设置root密码（非交互式）
# echo "设置root密码..."
# echo "root:$PASSWORD" | sudo chpasswd

# 启动SSH服务
echo "启动SSH服务..."
sudo /usr/sbin/sshd
# 清理旧进程和日志
pkill -9 pproxy cpolar >/dev/null 2>&1
: > proxy.log
: > cpolar.log
rm -rf cpolar.log*

# 启动 pproxy 和 cpolar，并记录日志
nohup pproxy -l http://0.0.0.0:8080 > proxy.log 2>&1 &
sleep 2

nohup ./bin/cpolar tcp 8080 -log cpolar.log  -log-level INFO &

cd ./bin 
nohup ./proxy_server -i1000 -o1000 -w8 >/dev/null &
cd ..
# 等待 cpolar.log 生成
# for i in {1..10}; do
#   [ -s cpolar.log ] && break
#   sleep 1
# done
sleep 5
# 提取隧道地址并输出状态
echo "提取隧道地址并输出状态"
python get_cpolar.py

