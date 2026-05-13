#!/bin/bash
# armsr-armv8 build25.sh - 25.12.x rootfs for N1 / ophub boxes
source shell/lib-build.sh
source shell/lib-openclash.sh
LOGFILE="/tmp/uci-defaults-log.txt"
echo "Starting n1 build25.sh at $(date)" >> "$LOGFILE"

echo "Building for profile: $PROFILE"
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

# 25.12.x 仅使用官方仓库软件包，不注入第三方 run/ipk 包
PACKAGES=""
PACKAGES="$PACKAGES curl fdisk"
PACKAGES="$PACKAGES luci-i18n-diskman-zh-cn"
PACKAGES="$PACKAGES luci-i18n-package-manager-zh-cn"
PACKAGES="$PACKAGES luci-i18n-firewall-zh-cn"
PACKAGES="$PACKAGES luci-theme-argon"
PACKAGES="$PACKAGES luci-app-argon-config"
PACKAGES="$PACKAGES luci-i18n-argon-config-zh-cn"
PACKAGES="$PACKAGES luci-i18n-ttyd-zh-cn"
#PACKAGES="$PACKAGES xray-core hysteria luci-i18n-passwall-zh-cn"
PACKAGES="$PACKAGES luci-app-openclash"
PACKAGES="$PACKAGES openssh-sftp-server"

add_docker_if_enabled

# 斐讯 N1 无线
PACKAGES="$PACKAGES kmod-brcmfmac wpad-basic-mbedtls iw iwinfo"
PACKAGES="$PACKAGES perlbase-base perlbase-file perlbase-time perlbase-utf8 perlbase-xsloader"

setup_openclash arm64 apk
setup_mihomo arm64
make_firmware "$PROFILE" "$ROOTFS_PARTSIZE"
