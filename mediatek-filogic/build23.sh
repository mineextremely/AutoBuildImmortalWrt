#!/bin/bash
# mediatek-filogic build23.sh - 23.05.4 firmware (for wr30u, ct3003, ax6000, 360t7 etc)
source shell/custom-packages.sh
source shell/switch_repository.sh
source shell/lib-build.sh
source shell/lib-openclash.sh
# imagebuilder容器内的build.sh

sync_third_party_ipk "https://github.com/mineextremely/store.git" "arm64"
inject_arch_priority

echo "Building for profile: $PROFILE"
echo "Include Docker: $INCLUDE_DOCKER"
create_pppoe_config

echo "$(date '+%Y-%m-%d %H:%M:%S') - Starting build process..."

PACKAGES=""
PACKAGES="$PACKAGES curl"
PACKAGES="$PACKAGES luci-i18n-firewall-zh-cn"
#PACKAGES="$PACKAGES luci-i18n-filebrowser-zh-cn"
PACKAGES="$PACKAGES luci-theme-argon"
#PACKAGES="$PACKAGES luci-app-argon-config"
#PACKAGES="$PACKAGES luci-i18n-argon-config-zh-cn"
#PACKAGES="$PACKAGES luci-i18n-diskman-zh-cn"
#23.05
PACKAGES="$PACKAGES luci-i18n-opkg-zh-cn"
PACKAGES="$PACKAGES luci-i18n-ttyd-zh-cn"
#PACKAGES="$PACKAGES luci-i18n-passwall-zh-cn"
#PACKAGES="$PACKAGES luci-app-openclash"
#PACKAGES="$PACKAGES luci-i18n-homeproxy-zh-cn"
PACKAGES="$PACKAGES openssh-sftp-server"
PACKAGES="$PACKAGES fdisk"
PACKAGES="$PACKAGES script-utils"
#PACKAGES="$PACKAGES luci-i18n-samba4-zh-cn"

PACKAGES="$PACKAGES $CUSTOM_PACKAGES"

add_docker_if_enabled

setup_openclash arm64 ipk
setup_mihomo arm64
make_firmware "$PROFILE" "" ""
