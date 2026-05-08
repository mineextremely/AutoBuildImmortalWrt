#!/bin/bash
# rockchip build24.sh - 24.10.x firmware for Rockchip devices
source shell/custom-packages.sh
source shell/switch_repository.sh
source shell/lib-build.sh
source shell/lib-openclash.sh
echo "第三方软件包: $CUSTOM_PACKAGES"
LOGFILE="/tmp/uci-defaults-log.txt"
echo "Starting 99-custom.sh at $(date)" >> $LOGFILE

echo "Building for profile: $PROFILE"
echo "Building for ROOTFS_PARTSIZE: $ROOTFS_PARTSIZE"

create_pppoe_config
sync_third_party_ipk "https://github.com/mineextremely/store.git" "arm64"
inject_arch_priority

echo "$(date '+%Y-%m-%d %H:%M:%S') - 开始构建固件..."
echo "查看repositories.conf信息——————"
cat repositories.conf

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
add_docker_if_enabled
# 文件管理器
#PACKAGES="$PACKAGES luci-i18n-filemanager-zh-cn"
PACKAGES="$PACKAGES $CUSTOM_PACKAGES"

setup_openclash arm64 ipk
make_firmware "$PROFILE" "$ROOTFS_PARTSIZE"
