#!/bin/bash
# rockchip build25.sh - 25.12.x firmware for Rockchip devices
source shell/lib-build.sh
source shell/lib-openclash.sh
LOGFILE="/tmp/uci-defaults-log.txt"
echo "Starting rockchip build25.sh at $(date)" >> "$LOGFILE"

echo "Building for profile: $PROFILE"
echo "Building for ROOTFS_PARTSIZE: $ROOTFS_PARTSIZE"

create_pppoe_config

echo "$(date '+%Y-%m-%d %H:%M:%S') - 开始构建 25.12.x 固件..."
echo "查看软件源配置----------------"
if [ -f repositories.conf ]; then
    cat repositories.conf
elif [ -f repositories.adb ]; then
    cat repositories.adb
else
    echo "未找到 repositories.conf 或 repositories.adb，继续使用 ImageBuilder 默认配置"
fi

# 25.12.x 使用 apk 包管理，保留官方仓库软件包，不集成第三方 run/ipk 包
PACKAGES=""
PACKAGES="$PACKAGES curl nano-full wget-ssl"
PACKAGES="$PACKAGES openssh-sftp-server"
#PACKAGES="$PACKAGES luci-i18n-diskman-zh-cn"
PACKAGES="$PACKAGES luci-i18n-package-manager-zh-cn"
PACKAGES="$PACKAGES luci-i18n-firewall-zh-cn"
PACKAGES="$PACKAGES luci-theme-argon"
PACKAGES="$PACKAGES luci-i18n-ttyd-zh-cn"
#USB网卡 mt7921AU的相关依赖
PACKAGES="$PACKAGES kmod-mt7921u iw-full iwinfo wpad-basic-mbedtls"

PACKAGES="$PACKAGES luci-app-openclash kmod-nft-tproxy"
#PACKAGES="$PACKAGES luci-i18n-filemanager-zh-cn"
add_docker_if_enabled

setup_openclash arm64 apk
make_firmware "$PROFILE" "$ROOTFS_PARTSIZE"
