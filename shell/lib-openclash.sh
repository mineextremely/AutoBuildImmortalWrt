# shell/lib-openclash.sh
# OpenClash core + client download (shared by all build24/build25 scripts)
# Usage: setup_openclash <arch> <pkg_format>
#   arch: arm64 | amd64 | amd64-v1
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
