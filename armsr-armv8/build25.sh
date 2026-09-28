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
PACKAGES="$PACKAGES luci-theme-footstrap"
#PACKAGES="$PACKAGES luci-theme-argon"
#PACKAGES="$PACKAGES luci-app-argon-config"
#PACKAGES="$PACKAGES luci-i18n-argon-config-zh-cn"
PACKAGES="$PACKAGES luci-i18n-ttyd-zh-cn"
#PACKAGES="$PACKAGES xray-core hysteria luci-i18n-passwall-zh-cn"
PACKAGES="$PACKAGES luci-app-openclash"
PACKAGES="$PACKAGES openssh-sftp-server"

add_docker_if_enabled

# 无线：kmod-brcmfmac 是斐讯N1 的 Broadcom 驱动，ophub 盒子流程不需要。
# FLOW 未设置时默认保留，避免将来新增流程漏配时静默丢掉驱动。
PACKAGES="$PACKAGES kmod-mt7921u kmod-phy-realtek wpad-basic-mbedtls iwinfo iw-full"
if [ "$FLOW" != "ophub" ]; then
    PACKAGES="$PACKAGES kmod-brcmfmac"
fi
PACKAGES="$PACKAGES perlbase-base perlbase-file perlbase-time perlbase-utf8 perlbase-xsloader"

# 精简 ImageBuilder 出厂产物：qcow2/vmdk/ext4/cpio/initramfs 在本流程中无人消费。
# N1 与 ophub 两个 workflow 都只取 *rootfs.tar.gz，.img.gz 由 ophub action 另行合成；
# 关闭后 rootfs.tar.gz 字节级不变（实测 md5 一致），少生成 7 个文件并省约 20% 构建时间。
# 之所以用 sed 而非签入 imm25.config：armsr 支持 SNAPSHOT 镜像，固定 config 会随快照漂移。
IMG_CFG=/home/build/immortalwrt/.config
if [ -f "$IMG_CFG" ]; then
    sed -i 's/^CONFIG_QCOW2_IMAGES=y/# CONFIG_QCOW2_IMAGES is not set/'                       "$IMG_CFG"
    sed -i 's/^CONFIG_VMDK_IMAGES=y/# CONFIG_VMDK_IMAGES is not set/'                         "$IMG_CFG"
    sed -i 's/^CONFIG_TARGET_ROOTFS_EXT4FS=y/# CONFIG_TARGET_ROOTFS_EXT4FS is not set/'       "$IMG_CFG"
    sed -i 's/^CONFIG_TARGET_ROOTFS_CPIOGZ=y/# CONFIG_TARGET_ROOTFS_CPIOGZ is not set/'       "$IMG_CFG"
    sed -i 's/^CONFIG_TARGET_ROOTFS_INITRAMFS=y/# CONFIG_TARGET_ROOTFS_INITRAMFS is not set/' "$IMG_CFG"
    echo "精简后的产物开关:"
    grep -E 'QCOW2_IMAGES|VMDK_IMAGES|ROOTFS_TARGZ|ROOTFS_EXT4FS|ROOTFS_SQUASHFS|ROOTFS_CPIOGZ|ROOTFS_INITRAMFS' "$IMG_CFG"
else
    echo "⚠️ 未找到 $IMG_CFG，跳过产物精简"
fi

setup_openclash arm64 apk
setup_mihomo arm64
make_firmware "$PROFILE" "$ROOTFS_PARTSIZE"
