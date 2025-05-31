#!/bin/bash

# 清理旧进程和日志
pkill -9 pproxy cpolar >/dev/null 2>&1
: > proxy.log
: > cpolar.log
rm -rf cpolar.log*

# 启动 pproxy 和 cpolar，并记录日志
nohup pproxy -l http://0.0.0.0:8080 > proxy.log 2>&1 &
sleep 2

nohup ./bin/cpolar tcp 8080 -log cpolar.log  -log-level INFO &

# 等待 cpolar.log 生成
# for i in {1..10}; do
#   [ -s cpolar.log ] && break
#   sleep 1
# done
sleep 5
# 提取隧道地址并输出状态
echo "提取隧道地址并输出状态"
python get_cpolar.py

