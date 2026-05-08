#!/bin/bash
# sunxi-cortexa53 build25.sh - 25.12.x firmware for Allwinner devices
source shell/apk-custom-packages.sh
source shell/lib-build.sh
source shell/lib-openclash.sh
echo "第三方APK软件包: $CUSTOM_PACKAGES"
LOGFILE="/tmp/uci-defaults-log.txt"
echo "Starting 99-custom.sh at $(date)" >> $LOGFILE
echo "Building for profile: $PROFILE"
echo "Building for ROOTFS_PARTSIZE: $ROOTFS_PARTSIZE"

create_pppoe_config
sync_third_party_apk "https://github.com/wukongdaily/apk.git" "arm64"

echo "$(date '+%Y-%m-%d %H:%M:%S') - 开始构建固件..."
echo "查看repositories信息——————"
cat repositories

PACKAGES=""
PACKAGES="$PACKAGES curl"
PACKAGES="$PACKAGES openssh-sftp-server"
PACKAGES="$PACKAGES luci-i18n-diskman-zh-cn"
PACKAGES="$PACKAGES luci-i18n-package-manager-zh-cn"
PACKAGES="$PACKAGES luci-i18n-firewall-zh-cn"
PACKAGES="$PACKAGES luci-theme-argon"
PACKAGES="$PACKAGES luci-app-argon-config"
PACKAGES="$PACKAGES luci-i18n-argon-config-zh-cn"
PACKAGES="$PACKAGES luci-i18n-ttyd-zh-cn"
PACKAGES="$PACKAGES xray-core hysteria luci-i18n-passwall-zh-cn"
PACKAGES="$PACKAGES luci-app-openclash"
PACKAGES="$PACKAGES luci-i18n-homeproxy-zh-cn"
PACKAGES="$PACKAGES luci-i18n-filemanager-zh-cn"
PACKAGES="$PACKAGES $CUSTOM_PACKAGES"

add_docker_if_enabled

setup_openclash arm64 apk
make_firmware "$PROFILE" "$ROOTFS_PARTSIZE"
