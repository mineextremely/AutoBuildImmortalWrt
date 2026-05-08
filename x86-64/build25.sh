#!/bin/bash
# x86-64 build25.sh - 25.12.x firmware for x86_64 devices
source shell/apk-custom-packages.sh
source shell/lib-build.sh
source shell/lib-openclash.sh
echo "第三方apk软件包: $CUSTOM_PACKAGES"
LOGFILE="/tmp/uci-defaults-log.txt"
echo "Starting 99-custom.sh at $(date)" >> $LOGFILE
echo "编译固件大小为: $PROFILE MB"
echo "Include Docker: $INCLUDE_DOCKER"

create_pppoe_config
sync_third_party_apk "https://github.com/wukongdaily/apk.git" "x86"

echo "$(date '+%Y-%m-%d %H:%M:%S') - 开始构建固件..."

PACKAGES=""
PACKAGES="$PACKAGES curl"
PACKAGES="$PACKAGES luci-i18n-diskman-zh-cn"
PACKAGES="$PACKAGES luci-i18n-firewall-zh-cn"
PACKAGES="$PACKAGES luci-theme-argon"
PACKAGES="$PACKAGES luci-app-argon-config"
PACKAGES="$PACKAGES luci-i18n-argon-config-zh-cn"
#25.12
PACKAGES="$PACKAGES luci-i18n-package-manager-zh-cn"
PACKAGES="$PACKAGES luci-i18n-ttyd-zh-cn"
PACKAGES="$PACKAGES xray-core hysteria luci-i18n-passwall-zh-cn"
PACKAGES="$PACKAGES luci-app-openclash"
PACKAGES="$PACKAGES luci-i18n-homeproxy-zh-cn"
PACKAGES="$PACKAGES openssh-sftp-server"
PACKAGES="$PACKAGES luci-i18n-filemanager-zh-cn"
PACKAGES="$PACKAGES $CUSTOM_PACKAGES"

add_docker_if_enabled

setup_openclash amd64-v1 apk
make_firmware "generic" "$PROFILE"
