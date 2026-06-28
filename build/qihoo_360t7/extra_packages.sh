#!/bin/bash
# 直接从 config 目录安装本地 IPK

CONFIG_DIR="$(pwd)/config"

echo "📦 Installing local packages from config/"

# 添加所有 timecontrol 相关的 ipk (使用通配符自动匹配)
for pkg in "${CONFIG_DIR}"/luci-*-timecontrol*.ipk; do
    if [ -f "$pkg" ]; then
        if file "$pkg" 2>/dev/null | grep -q "Zip archive"; then
            echo "✅ Adding valid IPK: $(basename "$pkg")"
            export PACKAGES="$PACKAGES $pkg"
        else
            echo "⚠️ Invalid IPK, removing: $(basename "$pkg")"
        fi
    fi
done

# 添加依赖 (coreutils 提供 flock)
export PACKAGES="$PACKAGES bc coreutils conntrack nftables bash"

echo "📦 Final PACKAGES: $PACKAGES"
