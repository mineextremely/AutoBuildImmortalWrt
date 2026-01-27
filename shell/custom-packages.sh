#!/bin/bash
# ============= imm仓库外的第三方插件==============
# ============= 若启用 则打开注释 ================
# ============= 但此文件也可以处理仓库内的软件去留 本质上是做了一个PACKAGES字符串的拼接 ================

# 各位注意 如果你构建的固件是硬路由 此文件的注释要酌情考虑是否打开 因为硬路由的闪存空间有限 若构建出来过大或者构建失败 记得调整本文件的注释
# 默认集成 iStore 商店
CUSTOM_PACKAGES="$CUSTOM_PACKAGES luci-app-store"

# 首页和网络向导
#CUSTOM_PACKAGES="$CUSTOM_PACKAGES luci-i18n-quickstart-zh-cn"
# 同样是代理相关 但以下2个属于imm仓库内的软件 一般在build24.sh中已经集成 你也可以在此处调整它的去留 若去除组件则使用减号- 若添加则 不使用减号 或者 不处理
#CUSTOM_PACKAGES="$CUSTOM_PACKAGES luci-app-openclash"
# 精简默认主题，非必要请勿启用
#CUSTOM_PACKAGES="$CUSTOM_PACKAGES -luci-theme-bootstrap"
# DDNS-GO by sirpdboy 
#CUSTOM_PACKAGES="$CUSTOM_PACKAGES ddns-go luci-i18n-ddns-go-zh-cn"
# 设置向导 by sirpdboy
#CUSTOM_PACKAGES="$CUSTOM_PACKAGES luci-app-netwizard luci-i18n-netwizard-zh-cn"
# 任务设置
#CUSTOM_PACKAGES="$CUSTOM_PACKAGES luci-app-taskplan luci-i18n-taskplan-zh-cn"
# 分区扩容 by sirpdboy 
#CUSTOM_PACKAGES="$CUSTOM_PACKAGES luci-app-partexp luci-i18n-partexp-zh-cn"
# 酷猫主题 by sirpdboy 
#CUSTOM_PACKAGES="$CUSTOM_PACKAGES luci-theme-kucat"
# 酷猫主题设置 by sirpdboy 
#CUSTOM_PACKAGES="$CUSTOM_PACKAGES luci-i18n-kucat-config-zh-cn"
# Aurora by eamonxg
#CUSTOM_PACKAGES="$CUSTOM_PACKAGES luci-theme-aurora"
# 进阶设置 by sirpdboy 
# 当luci-app-advancedplus插件开启时 需排除冲突项 luci-app-argon-config和luci-i18n-argon-config-zh-cn 减号代表排除
CUSTOM_PACKAGES="$CUSTOM_PACKAGES luci-app-advancedplus luci-i18n-advancedplus-zh-cn -luci-app-argon-config -luci-i18n-argon-config-zh-cn"
# Turbo ACC 网络加速
CUSTOM_PACKAGES="$CUSTOM_PACKAGES luci-app-turboacc"
# Easytier
CUSTOM_PACKAGES="$CUSTOM_PACKAGES easytier luci-i18n-easytier-zh-cn"
# tailscale
#CUSTOM_PACKAGES="$CUSTOM_PACKAGES tailscale luci-app-tailscale"
# floatip
CUSTOM_PACKAGES="$CUSTOM_PACKAGES floatip luci-i18n-floatip-zh-cn"
# natpierce
#CUSTOM_PACKAGES="$CUSTOM_PACKAGES luci-app-natpierce"
# 高级卸载 by YT Vedio Talk
CUSTOM_PACKAGES="$CUSTOM_PACKAGES luci-app-uninstall"
