#!/bin/bash
# 从本地 config/ 目录安装插件

# 设置路径
CONFIG_DIR="$(pwd)/config"
PKG_PATH="${CONFIG_DIR}"

echo "📦 Installing timecontrol packages from local config directory..."
echo "📁 Looking in: ${CONFIG_DIR}"

# 查找并添加 timecontrol IPK 文件
MAIN_PKG="luci-app-timecontrol_4.0.3-r20260121_all.ipk"
I18N_PKG="luci-i18n-timecontrol-zh-cn_26.020.48346.82e954c_all.ipk"

# 检查主程序
if [ -f "${CONFIG_DIR}/${MAIN_PKG}" ]; then
    if file "${CONFIG_DIR}/${MAIN_PKG}" 2>/dev/null | grep -q "Zip archive"; then
        echo "✅ Found valid IPK: ${MAIN_PKG}"
        export PACKAGES="$PACKAGES ${PKG_PATH}/${MAIN_PKG}"
    else
        echo "⚠️ Invalid IPK: ${MAIN_PKG}"
    fi
else
    echo "::warning::${MAIN_PKG} not found in ${CONFIG_DIR}"
    # 尝试通配符匹配
    FOUND=$(find "${CONFIG_DIR}" -maxdepth 1 -name "luci-app-timecontrol*.ipk" 2>/dev/null)
    if [ -n "$FOUND" ]; then
        echo "✅ Found alternative: $(basename "$FOUND")"
        export PACKAGES="$PACKAGES ${FOUND}"
    fi
fi

# 检查中文包
if [ -f "${CONFIG_DIR}/${I18N_PKG}" ]; then
    if file "${CONFIG_DIR}/${I18N_PKG}" 2>/dev/null | grep -q "Zip archive"; then
        echo "✅ Found valid IPK: ${I18N_PKG}"
        export PACKAGES="$PACKAGES ${PKG_PATH}/${I18N_PKG}"
    else
        echo "⚠️ Invalid IPK: ${I18N_PKG}"
    fi
else
    echo "::warning::${I18N_PKG} not found in ${CONFIG_DIR}"
    # 尝试通配符匹配
    FOUND=$(find "${CONFIG_DIR}" -maxdepth 1 -name "luci-i18n-timecontrol*.ipk" 2>/dev/null)
    if [ -n "$FOUND" ]; then
        echo "✅ Found alternative: $(basename "$FOUND")"
        export PACKAGES="$PACKAGES ${FOUND}"
    fi
fi

echo "📦 Current PACKAGES: $PACKAGES"
