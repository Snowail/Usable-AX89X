#!/bin/sh
#

########## SET THE CUSTOM VARIABLES ##########
# 设置程序安装目录
MAIN_DIR="/opt/usr/share"
#
# 设置自定义变量LATEST_VERSION为最新版adguardhome的版本号
LATEST_VERSION="$(curl -s "https://api.github.com/repos/AdguardTeam/AdGuardHome/releases/latest" | sed -E -n -e 's/^[[:space:]]*\"tag_name\":[[:space:]]*\"(.*)\".*/\1/p')"
#
# 设置自定义变量DOWNLOAD_LINK为最新版adguardhome的下载链接
DOWNLOAD_LINK="https://github.com/AdguardTeam/AdGuardHome/releases/download/${LATEST_VERSION}/AdGuardHome_linux_armv5.tar.gz"
#
# 设置环境变量ADMINUSER为路由器管理页面的登陆帐号
ADMINUSER="admin"
#
# 设置环境变量ADMINPASSWORD为路由器管理页面的登陆密码,是hash值
ADMINPASSWORD="$2a$10$HqWj6UaOP3S6hDl5v7siRupehkIlG/T8Wj2Tidp38KRSMIWALvO0u"
#
# 设置自定义变量DNS_PORT为ADGUARD-HOME的DNS服务监听端口
DNS_PORT="5053"
#
########## END ##########
#
#
########## INSTALL ADGUARD-HOME ##########
#
#
# 下载adguardhome包
/opt/bin/wget-ssl -c -t 10 -T 120 --no-cookies --no-check-certificate -P "${MAIN_DIR}" "${DOWNLOAD_LINK}"
#
# 解压adguardhome包
/opt/bin/tar -xzvf "${MAIN_DIR}/AdGuardHome_linux_armv5.tar.gz" -C "${MAIN_DIR}"
#
# 删除adguardhome包
rm -f "${MAIN_DIR}/AdGuardHome_linux_armv5.tar.gz"
#
# 配置adguardhome
echo -e "bind_host: 0.0.0.0\nbind_port: 3000" > "${MAIN_DIR}/AdGuardHome/AdGuardHome.yaml"
echo -e 'users:\n- name: '"${ADMINUSER}"'\n  password: '"${ADMINPASSWORD}"'' >> "${MAIN_DIR}/AdGuardHome/AdGuardHome.yaml"
echo -e "dns:\n  bind_host: 0.0.0.0\n  port: ${DNS_PORT}" >> "${MAIN_DIR}/AdGuardHome/AdGuardHome.yaml"
echo -e "  bootstrap_dns:\n  - 1.1.1.1\n  - 8.8.8.8" >> "${MAIN_DIR}/AdGuardHome/AdGuardHome.yaml"
echo -e "  upstream_dns:\n  - 223.5.5.5\n  - 114.114.114.114" >> "${MAIN_DIR}/AdGuardHome/AdGuardHome.yaml"
#
#
exit 0
########## END ##########
