#!/bin/bash
# armsr-armv8 build24.sh - 24.10.x rootfs for N1 / ophub boxes
source shell/custom-packages.sh
source shell/switch_repository.sh
source shell/lib-build.sh
source shell/lib-openclash.sh
echo "第三方软件包: $CUSTOM_PACKAGES"
LOGFILE="/tmp/uci-defaults-log.txt"
echo "Starting 99-custom.sh at $(date)" >> $LOGFILE

echo "Building for profile: $PROFILE"
echo "Building for ROOTFS_PARTSIZE: $ROOTFS_PARTSIZE"
echo "$(date '+%Y-%m-%d %H:%M:%S') - 开始构建arm64的rootfs.tar.gz"

PACKAGES=""
PACKAGES="$PACKAGES curl fdisk"
#PACKAGES="$PACKAGES luci-i18n-diskman-zh-cn"
PACKAGES="$PACKAGES luci-i18n-package-manager-zh-cn"
PACKAGES="$PACKAGES luci-i18n-firewall-zh-cn"
# 服务——FileBrowser 用户名admin 密码admin
#PACKAGES="$PACKAGES luci-i18n-filebrowser-go-zh-cn"
PACKAGES="$PACKAGES luci-theme-argon"
PACKAGES="$PACKAGES luci-app-argon-config"
PACKAGES="$PACKAGES luci-i18n-argon-config-zh-cn"
PACKAGES="$PACKAGES luci-i18n-ttyd-zh-cn"
#PACKAGES="$PACKAGES xray-core hysteria luci-i18n-passwall-zh-cn"
PACKAGES="$PACKAGES luci-app-openclash"
#PACKAGES="$PACKAGES luci-i18n-homeproxy-zh-cn"
PACKAGES="$PACKAGES openssh-sftp-server"
#PACKAGES="$PACKAGES luci-i18n-samba4-zh-cn"
# 文件管理器
#PACKAGES="$PACKAGES luci-i18n-filemanager-zh-cn"

add_docker_if_enabled

# 斐讯N1 无线
PACKAGES="$PACKAGES kmod-brcmfmac wpad-basic-mbedtls iw iwinfo"
PACKAGES="$PACKAGES perlbase-base perlbase-file perlbase-time perlbase-utf8 perlbase-xsloader"
# 晶晨宝盒（追加第三方必备软件 用于写入emmc 请不要注释）
CUSTOM_PACKAGES="$CUSTOM_PACKAGES luci-app-amlogic luci-i18n-amlogic-zh-cn"

echo "🔄 正在同步第三方软件仓库 Cloning run file repo..."
git clone --depth=1 https://github.com/mineextremely/store.git /tmp/store-run-repo
mkdir -p /home/build/immortalwrt/extra-packages
cp -r /tmp/store-run-repo/run/arm64/* /home/build/immortalwrt/extra-packages/
echo "✅ Run files copied to extra-packages:"
ls -lh /home/build/immortalwrt/extra-packages/*.run
sh shell/sync-packages.sh ipk
ls -lah /home/build/immortalwrt/packages/
inject_arch_priority

PACKAGES="$PACKAGES $CUSTOM_PACKAGES"

setup_openclash arm64 ipk
make_firmware "$PROFILE" "$ROOTFS_PARTSIZE"
