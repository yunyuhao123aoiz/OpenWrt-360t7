#!/bin/bash

# 定义临时目录和插件版本
TMP_DIR="/tmp/timecontrol_ipk"
PLUGIN_VERSION="v4.0.3" # 请前往Releases页面确认最新版本号

# 创建临时目录
mkdir -p "$TMP_DIR"
cd "$TMP_DIR" || exit

# 下载主程序和中文字体包
echo "正在下载 luci-app-timecontrol ..."
wget "https://github.com/TimouL/luci-app-timecontrol/releases/download/${PLUGIN_VERSION}/luci-app-timecontrol_${PLUGIN_VERSION#v}_all.ipk" -O luci-app-timecontrol.ipk

echo "正在下载 luci-i18n-timecontrol-zh-cn ..."
wget "https://github.com/TimouL/luci-app-timecontrol/releases/download/${PLUGIN_VERSION}/luci-i18n-timecontrol-zh-cn_${PLUGIN_VERSION#v}_all.ipk" -O luci-i18n-timecontrol-zh-cn.ipk

# 将IPK文件路径追加到PACKAGES变量中
# 注意：构建系统会处理这些本地IPK文件
export PACKAGES="$PACKAGES $TMP_DIR/luci-app-timecontrol.ipk $TMP_DIR/luci-i18n-timecontrol-zh-cn.ipk"

# 清理（可选）
# cd / && rm -rf "$TMP_DIR"
