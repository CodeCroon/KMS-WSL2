#!/bin/bash

if ! sudo -v; then
    # 如果 sudo -v 失败，提示用户并退出脚本
    echo "This script requires root privileges."
    exit 1
fi

INSTALL_SRC_DIR=$(dirname $(realpath "$0"))

temp_script=$(mktemp)
chmod +x "$temp_script"

# wsl-hosts
cat <<EOF > "$temp_script"
#!/bin/bash
install -T $INSTALL_SRC_DIR/wslhosts.service /usr/lib/systemd/system/wslhosts.service
install -T $INSTALL_SRC_DIR/init.wsl /etc/init.wsl

systemctl enable wslhosts.service

systemctl start wslhosts.service
EOF
sudo "$temp_script"

# vlmcsd service
cat <<EOF > "$temp_script"
#!/bin/bash
install -T $INSTALL_SRC_DIR/vlmcsd.service /usr/lib/systemd/system/vlmcsd.service
install -T $INSTALL_SRC_DIR/vlmcsd-x64-musl-static /usr/local/bin/vlmcsd

systemctl enable vlmcsd.service

systemctl start vlmcsd.service
EOF
sudo "$temp_script"

rm -f "$temp_script"

echo "请为 Windows 当前用户添加\`C:\Windows\System32\drivers\etc\hosts\`文件的写权限"
