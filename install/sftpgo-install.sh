#!/usr/bin/env bash

# Copyright (c) 2021-2025 tteck
# Author: tteck (tteckster)
# License: MIT
# https://github.com/community-scripts/ProxmoxVE/raw/main/LICENSE

source /dev/stdin <<< "$FUNCTIONS_FILE_PATH"
color
verb_ip6
catch_errors
setting_up_container
network_check
update_os

msg_info "Installing Dependencies"
$STD apt-get install -y curl
$STD apt-get install -y sudo
$STD apt-get install -y mc
$STD apt-get install -y gpg
$STD apt-get install -y sqlite3
$STD apt-get install -y wget
$STD apt-get install -y openssh-server
msg_ok "Installed Dependencies"

msg_info "Installing Golang"
$STD wget https://golang.org/dl/go1.23.2.linux-arm64.tar.gz
$STD tar -xzf go1.23.2.linux-arm64.tar.gz -C /usr/local
$STD ln -s /usr/local/go/bin/go /usr/local/bin/go
rm -rf go1.23.2.linux-arm64.tar.gz
msg_ok "Installed Golang"

msg_info "Installing SFTPGo"
curl -sS https://ftp.osuosl.org/pub/sftpgo/apt/gpg.key | gpg --dearmor -o /usr/share/keyrings/sftpgo-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/sftpgo-archive-keyring.gpg] https://ftp.osuosl.org/pub/sftpgo/apt bookworm main" >/etc/apt/sources.list.d/sftpgo.list
$STD apt-get update
$STD apt-get install -y sftpgo
msg_ok "Installed SFTPGo"

motd_ssh
customize

msg_info "Cleaning up"
$STD apt-get -y autoremove
$STD apt-get -y autoclean
msg_ok "Cleaned"
