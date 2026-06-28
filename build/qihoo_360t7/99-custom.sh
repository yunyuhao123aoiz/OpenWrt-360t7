#!/bin/sh
# 文件: build/qihoo_360t7/99-custom.sh
# 首次启动配置脚本

# 默认值（会被工作流替换）
hostname="yunyue"
ip_address="192.168.1.1"
netmask="255.255.255.0"

# 设置主机名
if [ -n "$hostname" ]; then
    echo "$hostname" > /proc/sys/kernel/hostname
    uci set system.@system[0].hostname="$hostname"
    uci commit system
fi

# 设置LAN IP
if [ -n "$ip_address" ] && [ -n "$netmask" ]; then
    uci set network.lan.ipaddr="$ip_address"
    uci set network.lan.netmask="$netmask"
    uci commit network
    # 重启网络服务应用配置
    /etc/init.d/network restart
fi

# 允许SSH从LAN访问
uci set dropbear.@dropbear[0].Interface='lan'
uci commit dropbear

# 写入固件描述信息
echo "ImmortalWrt $(cat /etc/openwrt_version) $(date +'%Y-%m-%d')" > /etc/banner

# 清理自身 (uci-defaults会在执行后自动删除)
exit 0
