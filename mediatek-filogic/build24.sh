#!/bin/bash
# mediatek-filogic build24.sh - 24.10.x firmware for MediaTek filogic routers
source shell/custom-packages.sh
source shell/switch_repository.sh
source shell/lib-build.sh
source shell/lib-openclash.sh
# imagebuilder容器内的build.sh

echo "🔄 正在同步第三方软件仓库 Cloning run file repo..."
git clone --depth=1 https://github.com/mineextremely/store.git /tmp/store-run-repo
mkdir -p /home/build/immortalwrt/extra-packages
cp -r /tmp/store-run-repo/run/arm64/* /home/build/immortalwrt/extra-packages/
echo "✅ Run files copied to extra-packages:"
ls -lh /home/build/immortalwrt/extra-packages/*.run
sh shell/sync-packages.sh ipk
ls -lah /home/build/immortalwrt/packages/
inject_arch_priority

echo "Building for profile: $PROFILE"
echo "Include Docker: $INCLUDE_DOCKER"
create_pppoe_config

echo "$(date '+%Y-%m-%d %H:%M:%S') - Starting build process..."

PACKAGES=""
PACKAGES="$PACKAGES relayd luci-proto-relay iw iwinfo nano-full htop"
PACKAGES="$PACKAGES curl luci luci-i18n-base-zh-cn"
PACKAGES="$PACKAGES luci-i18n-firewall-zh-cn"
PACKAGES="$PACKAGES luci-theme-argon"
#PACKAGES="$PACKAGES luci-app-argon-config"
#PACKAGES="$PACKAGES luci-i18n-argon-config-zh-cn"
#PACKAGES="$PACKAGES luci-i18n-diskman-zh-cn"
#24.10.0
PACKAGES="$PACKAGES luci-i18n-package-manager-zh-cn"
PACKAGES="$PACKAGES luci-i18n-ttyd-zh-cn"
PACKAGES="$PACKAGES openssh-sftp-server"
# 文件管理器
#PACKAGES="$PACKAGES luci-i18n-filemanager-zh-cn"

# 第三方软件包 合并 (AXT1800/AX1800不兼容)
if [ "$PROFILE" = "glinet_gl-axt1800" ] || [ "$PROFILE" = "glinet_gl-ax1800" ]; then
    echo "Model:$PROFILE not support third-parted packages"
    PACKAGES="$PACKAGES -luci-i18n-diskman-zh-cn luci-i18n-homeproxy-zh-cn"
else
    echo "Other Model:$PROFILE"
    PACKAGES="$PACKAGES $CUSTOM_PACKAGES"
fi

add_docker_if_enabled

setup_openclash arm64 ipk
setup_mihomo arm64
make_firmware "$PROFILE" "" ""
