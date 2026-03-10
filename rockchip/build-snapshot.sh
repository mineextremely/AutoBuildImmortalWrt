#!/bin/bash
# Log file for debugging
LOGFILE="/tmp/uci-defaults-log.txt"
echo "Starting build-snapshot.sh at $(date)" >> $LOGFILE

# yml 传入的路由器型号 PROFILE
echo "Building for profile: $PROFILE"
# yml 传入的固件大小 ROOTFS_PARTSIZE
echo "Building for ROOTFS_PARTSIZE: $ROOTFS_PARTSIZE"

echo "Create pppoe-settings"
mkdir -p  /home/build/immortalwrt/files/etc/config

# 创建pppoe配置文件 yml传入环境变量ENABLE_PPPOE等 写入配置文件 供99-custom.sh读取
cat << EOF > /home/build/immortalwrt/files/etc/config/pppoe-settings
enable_pppoe=${ENABLE_PPPOE}
pppoe_account=${PPPOE_ACCOUNT}
pppoe_password=${PPPOE_PASSWORD}
EOF

echo "cat pppoe-settings"
cat /home/build/immortalwrt/files/etc/config/pppoe-settings

# 输出调试信息
echo "$(date '+%Y-%m-%d %H:%M:%S') - 开始构建固件..."
echo "查看repositories.conf信息——————"
cat repositories.conf

# 定义所需安装的包列表（仅使用官方APK包）
PACKAGES="$PACKAGES kmod-mt7921u kmod-nft-tproxy kmod-tcp-bbr"
PACKAGES="$PACKAGES curl iw-full iwinfo wpad-basic-mbedtls"
PACKAGES="$PACKAGES openssh-sftp-server"
PACKAGES="$PACKAGES luci-i18n-diskman-zh-cn"
PACKAGES="$PACKAGES luci-i18n-package-manager-zh-cn"
PACKAGES="$PACKAGES luci-i18n-firewall-zh-cn"
PACKAGES="$PACKAGES luci-theme-argon"
#PACKAGES="$PACKAGES luci-app-argon-config"
#PACKAGES="$PACKAGES luci-i18n-argon-config-zh-cn"
PACKAGES="$PACKAGES luci-i18n-ttyd-zh-cn"
# 文件管理器
PACKAGES="$PACKAGES luci-i18n-filemanager-zh-cn"
# OpenClash（官方APK包）
PACKAGES="$PACKAGES luci-app-openclash"

# 构建镜像
echo "$(date '+%Y-%m-%d %H:%M:%S') - Building image with the following packages:"
echo "$PACKAGES"

# 添加架构优先级信息
#sed -i '1i arch aarch64_generic 10' repositories.conf
#sed -i '1i arch aarch64_cortex-a53 15' repositories.conf

# 集成 OpenClash 核心下载
if echo "$PACKAGES" | grep -q "luci-app-openclash"; then
    echo "✅ 已选择 luci-app-openclash，添加 openclash core"
    mkdir -p files/etc/openclash/core
    # Download clash_meta
    META_URL="https://raw.githubusercontent.com/vernesong/OpenClash/core/dev/smart/clash-linux-arm64.tar.gz"
    wget -qO- $META_URL | tar xOvz > files/etc/openclash/core/clash_meta
    chmod +x files/etc/openclash/core/clash_meta
else
    echo "⚪️ 未选择 luci-app-openclash"
fi

make image PROFILE=$PROFILE PACKAGES="$PACKAGES" FILES="/home/build/immortalwrt/files" ROOTFS_PARTSIZE=$ROOTFS_PARTSIZE

if [ $? -ne 0 ]; then
    echo "$(date '+%Y-%m-%d %H:%M:%S') - Error: Build failed!"
    exit 1
fi

echo "$(date '+%Y-%m-%d %H:%M:%S') - Build completed successfully."