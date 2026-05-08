# shell/lib-build.sh
# Common build helpers shared by all platform build scripts

# --- PPPoE config ---
create_pppoe_config() {
    echo "Create pppoe-settings"
    mkdir -p /home/build/immortalwrt/files/etc/config
    cat << EOF > /home/build/immortalwrt/files/etc/config/pppoe-settings
enable_pppoe=${ENABLE_PPPOE}
pppoe_account=${PPPOE_ACCOUNT}
pppoe_password=${PPPOE_PASSWORD}
EOF
    echo "cat pppoe-settings"
    cat /home/build/immortalwrt/files/etc/config/pppoe-settings
}

# --- Third-party repo sync (24.x / opkg) ---
sync_third_party_ipk() {
    local repo_url="${1:-https://github.com/mineextremely/store.git}"
    local arch_dir="${2:-arm64}"

    if [ -z "$CUSTOM_PACKAGES" ]; then
        echo "⚪️ 未选择 任何第三方软件包"
        return 0
    fi

    echo "🔄 正在同步第三方软件仓库 Cloning run file repo..."
    git clone --depth=1 "$repo_url" /tmp/store-run-repo

    mkdir -p /home/build/immortalwrt/extra-packages
    cp -r /tmp/store-run-repo/run/${arch_dir}/* /home/build/immortalwrt/extra-packages/

    echo "✅ Run files copied to extra-packages:"
    ls -lh /home/build/immortalwrt/extra-packages/*.run
    sh shell/sync-packages.sh ipk
    ls -lah /home/build/immortalwrt/packages/
}

# --- Third-party repo sync (25.x / apk) ---
sync_third_party_apk() {
    local repo_url="${1:-https://github.com/wukongdaily/apk.git}"
    local arch_dir="${2:-arm64}"

    if [ -z "$CUSTOM_PACKAGES" ]; then
        echo "⚪️ 未选择 任何第三方软件包"
        return 0
    fi

    echo "🔄 正在同步第三方软件仓库 Cloning apk file repo..."
    git clone --depth=1 "$repo_url" /tmp/store-apk-repo

    mkdir -p /home/build/immortalwrt/extra-packages
    cp -r /tmp/store-apk-repo/run/${arch_dir}/* /home/build/immortalwrt/extra-packages/

    echo "✅ Run files copied to extra-packages:"
    sh shell/sync-packages.sh apk
    ls -lah /home/build/immortalwrt/packages/
}

# --- Docker conditional ---
add_docker_if_enabled() {
    if [ "$INCLUDE_DOCKER" = "yes" ]; then
        PACKAGES="$PACKAGES luci-i18n-dockerman-zh-cn"
        echo "Adding package: luci-i18n-dockerman-zh-cn"
    fi
}

# --- arch priority injection (24.x only, for mixed-arch devices) ---
inject_arch_priority() {
    sed -i '1i\
arch aarch64_generic 10\n\
arch aarch64_cortex-a53 15' repositories.conf
}

# --- Standard make image call ---
# Usage: make_firmware [profile] [rootfs_size] [extra_args]
make_firmware() {
    local profile="${1:-$PROFILE}"
    local rootfs_size="${2:-$ROOTFS_PARTSIZE}"
    echo "$(date '+%Y-%m-%d %H:%M:%S') - Building image with the following packages:"
    echo "$PACKAGES"

    make image PROFILE="$profile" PACKAGES="$PACKAGES" \
        FILES="/home/build/immortalwrt/files" \
        ROOTFS_PARTSIZE="$rootfs_size" \
        ${3:-}

    if [ $? -ne 0 ]; then
        echo "$(date '+%Y-%m-%d %H:%M:%S') - Error: Build failed!"
        exit 1
    fi
    echo "$(date '+%Y-%m-%d %H:%M:%S') - Build completed successfully."
}
