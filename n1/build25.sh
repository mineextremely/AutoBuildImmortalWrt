#!/bin/bash
# Log file for debugging

LOGFILE="/tmp/uci-defaults-log.txt"
echo "Starting n1 build25.sh at $(date)" >> "$LOGFILE"

# yml 传入的路由器型号 PROFILE
echo "Building for profile: $PROFILE"
# yml 传入的固件大小 ROOTFS_PARTSIZE
echo "Building for ROOTFS_PARTSIZE: $ROOTFS_PARTSIZE"
echo "$(date '+%Y-%m-%d %H:%M:%S') - 开始构建 arm64 的 rootfs.tar.gz"

echo "查看软件源配置----------------"
if [ -f repositories.conf ]; then
    cat repositories.conf
elif [ -f repositories.adb ]; then
    cat repositories.adb
else
    echo "未找到 repositories.conf 或 repositories.adb，继续使用 ImageBuilder 默认配置"
fi

# 25.12.x 实验版仅使用官方仓库软件包，不注入第三方 run/ipk 包
PACKAGES=""
PACKAGES="$PACKAGES curl fdisk"
PACKAGES="$PACKAGES luci-i18n-diskman-zh-cn"
PACKAGES="$PACKAGES luci-i18n-package-manager-zh-cn"
PACKAGES="$PACKAGES luci-i18n-firewall-zh-cn"
PACKAGES="$PACKAGES luci-theme-argon"
PACKAGES="$PACKAGES luci-app-argon-config"
PACKAGES="$PACKAGES luci-i18n-argon-config-zh-cn"
PACKAGES="$PACKAGES luci-i18n-ttyd-zh-cn"
PACKAGES="$PACKAGES xray-core hysteria luci-i18n-passwall-zh-cn"
PACKAGES="$PACKAGES luci-app-openclash"
PACKAGES="$PACKAGES openssh-sftp-server"

if [ "$INCLUDE_DOCKER" = "yes" ]; then
    PACKAGES="$PACKAGES luci-i18n-dockerman-zh-cn"
    echo "✅ 已选择 docker : luci-i18n-dockerman-zh-cn"
fi

# 斐讯 N1 无线
PACKAGES="$PACKAGES kmod-brcmfmac wpad-basic-mbedtls iw iwinfo"
PACKAGES="$PACKAGES perlbase-base perlbase-file perlbase-time perlbase-utf8 perlbase-xsloader"

if echo "$PACKAGES" | grep -q "luci-app-openclash"; then
    echo "✅ 已选择 luci-app-openclash，添加 openclash core"
    mkdir -p files/etc/openclash/core
    META_URL="https://raw.githubusercontent.com/vernesong/OpenClash/core/dev/smart/clash-linux-arm64.tar.gz"
    wget -qO- "$META_URL" | tar xOvz > files/etc/openclash/core/clash_meta
    chmod +x files/etc/openclash/core/clash_meta
else
    echo "⚪️ 未选择 luci-app-openclash"
fi

echo "$(date '+%Y-%m-%d %H:%M:%S') - Building image with the following packages:"
echo "$PACKAGES"

make image PROFILE=$PROFILE PACKAGES="$PACKAGES" FILES="/home/build/immortalwrt/files" ROOTFS_PARTSIZE=$ROOTFS_PARTSIZE

if [ $? -ne 0 ]; then
    echo "$(date '+%Y-%m-%d %H:%M:%S') - Error: Build failed!"
    exit 1
fi

echo "$(date '+%Y-%m-%d %H:%M:%S') - Build completed successfully."
