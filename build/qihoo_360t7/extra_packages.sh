#!/bin/bash
# 360 T7 自定义插件 - 使用opkg源安装

echo "📥 Setting up timecontrol package repository..."

# 进入imagebuilder目录
cd imagebuilder || exit 1

# 添加公钥
wget -q -O /tmp/timecontrol.pub https://timoul.github.io/luci-app-timecontrol/key-build.pub
opkg-key add /tmp/timecontrol.pub

# 添加软件源到repositories.conf
if ! grep -q "timecontrol" repositories.conf; then
    echo "src/gz timecontrol https://timoul.github.io/luci-app-timecontrol" >> repositories.conf
    echo "✅ Added timecontrol feed"
fi

# 更新包列表
make package_index

# 添加包到PACKAGES
export PACKAGES="$PACKAGES luci-app-timecontrol luci-i18n-timecontrol-zh-cn"

echo "✅ Timecontrol packages added to build"
