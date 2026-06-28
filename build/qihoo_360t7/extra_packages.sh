#!/bin/bash
# 使用opkg源安装timecontrol插件

# 添加公钥
echo "📥 Adding public key..."
wget -q -O /tmp/timecontrol.pub https://timoul.github.io/luci-app-timecontrol/key-build.pub
opkg-key add /tmp/timecontrol.pub

# 添加软件源
echo "📥 Adding custom feed..."
echo "src/gz timecontrol https://timoul.github.io/luci-app-timecontrol" >> imagebuilder/repositories.conf

# 更新包列表
echo "📥 Updating package list..."
cd imagebuilder
make package_index

# 安装插件 (通过包名)
echo "📦 Adding timecontrol packages..."
export PACKAGES="$PACKAGES luci-app-timecontrol luci-i18n-timecontrol-zh-cn"
