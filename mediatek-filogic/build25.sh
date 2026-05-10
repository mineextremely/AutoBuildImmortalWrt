#!/bin/bash
# mediatek-filogic build25.sh - 25.12.x firmware for MediaTek filogic routers
source shell/apk-custom-packages.sh
source shell/lib-build.sh
source shell/lib-openclash.sh
#echo "✅ 你选择了第三方软件包：$CUSTOM_PACKAGES"
sync_third_party_apk "https://github.com/wukongdaily/apk.git" "arm64"

echo "Building for profile: $PROFILE"
echo "Include Docker: $INCLUDE_DOCKER"
create_pppoe_config

echo "$(date '+%Y-%m-%d %H:%M:%S') - Starting build process..."

PACKAGES=""
PACKAGES="$PACKAGES curl luci luci-i18n-base-zh-cn"
PACKAGES="$PACKAGES luci-i18n-firewall-zh-cn"
PACKAGES="$PACKAGES luci-theme-argon"
PACKAGES="$PACKAGES luci-app-argon-config"
PACKAGES="$PACKAGES luci-i18n-argon-config-zh-cn"
#PACKAGES="$PACKAGES luci-i18n-diskman-zh-cn"
PACKAGES="$PACKAGES luci-i18n-package-manager-zh-cn"
PACKAGES="$PACKAGES luci-i18n-ttyd-zh-cn"
PACKAGES="$PACKAGES openssh-sftp-server"
# 文件管理器
#PACKAGES="$PACKAGES luci-i18n-filemanager-zh-cn"

PACKAGES="$PACKAGES $CUSTOM_PACKAGES"

add_docker_if_enabled

setup_openclash arm64 apk
setup_mihomo arm64
make_firmware "$PROFILE" "" ""
