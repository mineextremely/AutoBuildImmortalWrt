# shell/lib-openclash.sh
# OpenClash core + client download (shared by all build24/build25 scripts)
# Usage: setup_openclash <arch> <pkg_format>
#   arch: arm64 | amd64 | amd64-v3
#   pkg_format: ipk | apk

setup_openclash() {
    local arch="${1:-arm64}"
    local pkg_fmt="${2:-ipk}"

    if ! echo "$PACKAGES" | grep -q "luci-app-openclash"; then
        echo "⚪️ 未选择 luci-app-openclash"
        return 0
    fi

    echo "✅ 已选择 luci-app-openclash，添加 openclash core"
    mkdir -p files/etc/openclash/core

    local META_URL="https://raw.githubusercontent.com/vernesong/OpenClash/core/dev/smart/clash-linux-${arch}.tar.gz"
    wget -qO- "$META_URL" | tar xOvz > files/etc/openclash/core/clash_meta
    chmod +x files/etc/openclash/core/clash_meta

    local URL
    URL=$(curl -s https://api.github.com/repos/vernesong/OpenClash/releases/latest \
      | grep "browser_download_url.*${pkg_fmt}" \
      | head -n1 \
      | cut -d '"' -f 4)
    echo "OpenClash latest ${pkg_fmt}: $URL"
    wget "$URL" -P /home/build/immortalwrt/packages/
}

# shell/lib-openclash.sh (continued)
# mihomo core download for luci-app-ssr-plus
# Usage: setup_mihomo <arch>
#   arch: arm64 | amd64

setup_mihomo() {
    local arch="${1:-arm64}"
    local md_arch="arm64"
    [ "$arch" = "amd64" ] && md_arch="amd64-compatible"

    if ! echo "$PACKAGES" | grep -q "luci-app-ssr-plus"; then
        echo "⚪️ 未选择 luci-app-ssr-plus"
        return 0
    fi

    echo "✅ 已选择 luci-app-ssr-plus，添加 mihomo core"
    mkdir -p files/usr/bin
    local MIHOMO_URL="https://github.com/MetaCubeX/mihomo/releases/download/v1.19.24/mihomo-linux-${md_arch}-v1.19.24.gz"
    wget -qO- "$MIHOMO_URL" | gzip -dc > files/usr/bin/mihomo
    chmod +x files/usr/bin/mihomo
    echo "✅ 已下载 mihomo core"
    ls -lah files/usr/bin
}
