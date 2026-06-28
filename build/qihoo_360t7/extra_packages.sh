#!/bin/bash
# 360 T7 自定义插件 - 直接从GitHub下载IPK

PLUGIN_VERSION="v4.0.3"
PKG_DIR="imagebuilder/packages"
BASE_URL="https://github.com/TimouL/luci-app-timecontrol/releases/download/${PLUGIN_VERSION}"

mkdir -p "$PKG_DIR"

echo "📥 Downloading timecontrol packages from GitHub..."

# 下载主程序包
MAIN_PKG="luci-app-timecontrol_${PLUGIN_VERSION#v}_all.ipk"
if [ ! -f "${PKG_DIR}/${MAIN_PKG}" ]; then
    echo "📥 Downloading ${MAIN_PKG}..."
    if wget -q --timeout=30 "${BASE_URL}/${MAIN_PKG}" -O "${PKG_DIR}/${MAIN_PKG}"; then
        # 验证文件
        if file "${PKG_DIR}/${MAIN_PKG}" | grep -q "Zip archive"; then
            echo "✅ Downloaded ${MAIN_PKG} (valid IPK)"
        else
            echo "⚠️ ${MAIN_PKG} is not a valid IPK, removing..."
            rm -f "${PKG_DIR}/${MAIN_PKG}"
        fi
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
    if wget -q --timeout=30 "${BASE_URL}/${I18N_PKG}" -O "${PKG_DIR}/${I18N_PKG}"; then
        if file "${PKG_DIR}/${I18N_PKG}" | grep -q "Zip archive"; then
            echo "✅ Downloaded ${I18N_PKG} (valid IPK)"
        else
            echo "⚠️ ${I18N_PKG} is not a valid IPK, removing..."
            rm -f "${PKG_DIR}/${I18N_PKG}"
        fi
    else
        echo "::warning::Failed to download ${I18N_PKG}"
    fi
else
    echo "✅ ${I18N_PKG} already exists"
fi

# 检查哪些包下载成功，并添加到PACKAGES
PKG_PATH="$(pwd)/${PKG_DIR}"
for pkg in "${PKG_DIR}"/*timecontrol*.ipk; do
    if [ -f "$pkg" ]; then
        if file "$pkg" 2>/dev/null | grep -q "Zip archive"; then
            echo "✅ Adding valid IPK: $(basename "$pkg")"
            export PACKAGES="$PACKAGES ${PKG_PATH}/$(basename "$pkg")"
        else
            echo "⚠️ Removing invalid IPK: $(basename "$pkg")"
            rm -f "$pkg"
        fi
    fi
done

echo "📦 Current PACKAGES: $PACKAGES"
