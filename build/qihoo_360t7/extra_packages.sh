#!/bin/bash
# 文件: build/qihoo_360t7/extra_packages.sh
# 从GitHub Releases下载预编译IPK并添加到构建

# 插件版本 (请定期检查更新: https://github.com/TimouL/luci-app-timecontrol/releases)
PLUGIN_VERSION="v4.0.3"

# 工作流已创建的包目录
PKG_DIR="imagebuilder/packages"

# 确保目录存在
mkdir -p "$PKG_DIR"

# 构建下载URL
BASE_URL="https://github.com/TimouL/luci-app-timecontrol/releases/download/${PLUGIN_VERSION}"

# 下载主程序包
MAIN_PKG="luci-app-timecontrol_${PLUGIN_VERSION#v}_all.ipk"
if [ ! -f "${PKG_DIR}/${MAIN_PKG}" ]; then
    echo "📥 Downloading ${MAIN_PKG}..."
    if wget -q "${BASE_URL}/${MAIN_PKG}" -O "${PKG_DIR}/${MAIN_PKG}"; then
        echo "✅ Downloaded ${MAIN_PKG}"
    else
        echo "::warning::Failed to download ${MAIN_PKG}"
    fi
else
    echo "✅ ${MAIN_PKG} already exists"
fi

# 下载中文语言包
I18N_PKG="luci-i18n-timecontrol-zh-cn_${PLUGIN_VERSION#v}_all.ipk"
if [ ! -f "${PKG_DIR}/${I18N_PKG}" ]; then
    echo "📥 Downloading ${I18N_PKG}..."
    if wget -q "${BASE_URL}/${I18N_PKG}" -O "${PKG_DIR}/${I18N_PKG}"; then
        echo "✅ Downloaded ${I18N_PKG}"
    else
        echo "::warning::Failed to download ${I18N_PKG}"
    fi
else
    echo "✅ ${I18N_PKG} already exists"
fi

# 将IPK文件路径追加到PACKAGES变量
# 使用绝对路径以确保make image能够找到
PKG_PATH="$(pwd)/${PKG_DIR}"
if [ -f "${PKG_DIR}/${MAIN_PKG}" ]; then
    export PACKAGES="$PACKAGES ${PKG_PATH}/${MAIN_PKG}"
    echo "✅ Added ${MAIN_PKG} to packages"
fi
if [ -f "${PKG_DIR}/${I18N_PKG}" ]; then
    export PACKAGES="$PACKAGES ${PKG_PATH}/${I18N_PKG}"
    echo "✅ Added ${I18N_PKG} to packages"
fi

echo "📦 Current packages: $PACKAGES"
